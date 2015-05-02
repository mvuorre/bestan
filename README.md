# bestan

Robust bayesian estimation, the Stan version. 

The package is currently at version 0.1. Proceed with caution.

## Background

This R-package implements John Kruschke's model described in [Kruschke, 2013](http://psycnet.apa.org/journals/xge/142/2/573), for Bayesian estimation for two groups (BEST). The [original software](http://www.indiana.edu/~kruschke/BEST/), and its [later implementation in R](https://github.com/mikemeredith/BEST), use [JAGS](http://mcmc-jags.sourceforge.net/) for MCMC sampling. This package uses [Stan](http://mc-stan.org/) as the MCMC sampler.

For real practical applications, I recommend using the original implementation.

While working on the Stan implementation, I stumbled across [Michael Clark's github repository](https://github.com/mclark--/Miscellaneous-R-Code/blob/master/ModelFitting/Bayesian/rstant_testBEST.R), that already has a (better) Stan implementation of the BEST model.

## Information

bestan is probably only useful if one wants to examine and learn how to implement a simple model in Stan. It is currently not complete in any sense of the word, but handles the simple two group situation. The object returned by ```bestan``` is a ```stanfit``` object, and can therefore be used for all the relevant functions in rstan, and [ggmcmc](http://cran.r-project.org/web/packages/ggmcmc/index.html) for example.

## Examples

### Install bestan

```
install.packages("devtools")
library(devtools)
install_github("mvuorre/bestan")
```

Instructions on how to install rstan can be found on the [project website](http://mc-stan.org/)

### Compare two groups

```
g1 <- rnorm(16, 10, 5)
g2 <- rnorm(32, 7, 3)
fit <- bestan(y1=g1, y2=g2)
fit
bestan_plot(fit)
```

Another example can be found [here](http://rpubs.com/mv2521/bestan01)

