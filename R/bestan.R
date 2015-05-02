#' BEST: Stan edition
#'
#' Use bestan() to compare two groups.
#' @param y1 A vector of values for group 1
#' @param y2 A vector of values for group 2
#' @param iters Number of MCMC iterations. Defaults to same as original BEST.
#' @examples
#' group_1 <- rnorm(20, 10, 5)
#' group_2 <- rnorm(20, 0, 2)
#' bestan(y1=group_1, y2=group_2)

bestan <- function(y1, y2, iters=1.1e+05){

    # Create outcome vector
    y <- c(y1, y2)

    # Create group ID vector
    group_id <- c(rep(1, length(y1)), rep(2, length(y2)))

    # data list for Stan
    data_list <- list(
        y = y,
        group_id = group_id,
        n1 = length(y1),
        n2 = length(y2),
        N = length(y),
        mu_prior_location = mean(y),
        mu_prior_scale = sd(y) * 1000,
        sigma_prior_lower = sd(y) / 1000,
        sigma_prior_upper = sd(y) * 1000
    )

    # Save model into string
    model_string <- "
    data {
        int N;
        real y[N];
        int group_id[N];
        real mu_prior_location;
        real mu_prior_scale;
        real sigma_prior_lower;
        real sigma_prior_upper;
        int n1;
        int n2;
    }

    parameters {
        real mu[2];
        real<lower=0, upper=1000> sigma[2];
        real<lower=0, upper=1000> nu;
    }

    model {
        mu ~ normal(mu_prior_location, mu_prior_scale);
        sigma ~ uniform(sigma_prior_lower, sigma_prior_upper);
        nu ~ exponential(1.0/29.0);
        for (i in 1:N)
            y[i] ~ student_t(nu, mu[group_id[i]], sigma[group_id[i]]);
    }

    generated quantities {
        real diff_mu;
        real cohens_d;
        diff_mu <- mu[1] - mu[2];
        cohens_d <- diff_mu / sqrt(( n1*sigma[1]^2 + n2*sigma[2]^2) / (n1+n2-2));
    }
    "

    # Compile Stan model
    # If user makes changes, need to recompile model
    if (!exists("model_dso")){
        model_dso <- rstan::stan_model(model_code = model_string, model_name = "bestan")
    }
    # saveRDS(model_dso, file = 'model_DSO.rds')

    # Load compiled model
    # model_dso <- readRDS("model_DSO.rds")

    # Sample from model
    samples <- rstan::sampling(model_dso, data_list,
                               chains=1, iter=iters, warmup=1000)
    return(samples)
}
