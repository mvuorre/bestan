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

bestan <- function(y1, y2, iters=110000){

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

    # Sample from model
    model_file <- system.file("stan/twogroups.stan", package="bestan")
    samples <- stan(file=model_file, data=data_list,
                    chains=1, iter=iters, warmup=10000)
    return(samples)
}
