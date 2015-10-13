#' BEST: Stan edition
#'
#' Use bestan_oneway() to compare multiple groups.
#' @param grouping A vector of grouping factor IDs
#' @param value A vector of outcome values
#' @param iters Number of MCMC iterations.
#' @examples
#'

bestan_oneway <- function(df, outcome, grouping, iters=1.1e+05){

    df <- read.csv("FruitflyDataReduced.csv", stringsAsFactors = F)
    y <- df$Longevity
    x <- as.numeric(as.factor(df$CompanionNumber))

    # data list for Stan
    data_list <- list(
        y = y,
        x = x,
        N = length(y),
        J = length(unique(x)),
        mu_prior_location = mean(y),
        mu_prior_scale = sd(y) * 1000,
        sigma_prior_lower = sd(y) / 1000,
        sigma_prior_upper = sd(y) * 1000
    )

    # Save model into string
    model_string <- "
    data {
        int<lower=1> N;                     // Total observations
        int<lower=1> J;                     // Number of groups
        real y[N];                          // Outcome vector
        int<lower=1> x[N];                  // Predictor (group ID vector)
        real mu_prior_location;
        real mu_prior_scale;
        real sigma_prior_lower;
        real sigma_prior_upper;

    }

    parameters {
        real a0;                            // Unconstrained grand mean
        real a[J];                          // Unconstrained deflections
        real<lower=0> a_sigma;              // Hyperprior on deflections
        real<lower=0> sigma;                // Residual
    }

    transformed parameters {
        // Implement sum-to-zero constraint
        real m[J];                          // Means
        real b0;                            // Grand mean
        real b[J];                          // Sum-to-zero deflections
        for (j in 1:J)
            m[j] <- a0 + a[j];
        b0 <- mean(m);
        for (j in 1:J)
            b[j] <- m[j] - b0;
    }

    model {
        // Priors
        a0 ~ normal(mu_prior_location, mu_prior_scale);
        a_sigma ~ uniform(0, 1000);         // Bad prior
        a ~ normal(0.0, a_sigma);           // Note shrinkage
        sigma ~ uniform(sigma_prior_lower, sigma_prior_upper);
        // 'Sampling statement'
        for (i in 1:N)
            y[i] ~ normal(a0 + a[x[i]], sigma);
    }
    "

    # Compile Stan model
    model_dso <- rstan::stan_model(model_code = model_string, model_name = "bestan")

    # Sample from model
    samples <- rstan::sampling(model_dso, data_list,
                               chains=1, iter=iters, warmup=1000)
    return(samples)
}
