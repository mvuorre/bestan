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
