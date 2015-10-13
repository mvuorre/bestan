quants <- function(x) {
    m <- quantile(x, probs=.5)
    xmin <- quantile(x, probs=.1)
    xmax <- quantile(x, probs=.9)
    return(data.frame(y=m,xmin=xmin,xmax=xmax))
}
