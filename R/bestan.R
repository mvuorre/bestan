bestan <- function(y1, y2){

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

    # Compile Stan model
    # If user makes changes, need to recompile model
    # model_code <- rstan::stan_model(file='model.stan', model_name = "bestan")
    # save(model_code, file = 'm.RData')

    # Load compiled model
    load("m.RData")

    # Sample from model
    print("Sampling...")
    samples <- rstan::sampling(model_code, data_list,
                               chains=1, iter=1.1e+04, warmup=1000)
    print("Done sampling.")
    return(samples)
}
