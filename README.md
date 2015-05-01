bestan

This R-package implements John Kruschke's model described in [Kruschke, 2013](http://psycnet.apa.org/journals/xge/142/2/573), for Bayesian estimation for two groups (BEST). The [original software](http://www.indiana.edu/~kruschke/BEST/), and its [later implementation in R](https://github.com/mikemeredith/BEST), use [JAGS](http://mcmc-jags.sourceforge.net/) for MCMC sampling. This package uses [Stan](http://mc-stan.org/) as the MCMC sampler, but for the same model.

For real practical applications, I recommend users to stick with the original implementation.

While working on the Stan implementation, I stumbled across [Michael Clark's github repository](https://github.com/mclark--/Miscellaneous-R-Code/blob/master/ModelFitting/Bayesian/rstant_testBEST.R), that already has a (better) Stan implementation of the BEST model.
