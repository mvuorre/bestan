bestan_plot <- function(stanobj){

    # Parameter posterior distribution
    bestan_df <- as.data.frame(stanobj) %>%
        select(-matches("lp__")) %>%
        mutate(nu_log10 = log10(nu))

    # Plot posterior medians and 2.5 & 97.5 percentiles
    ggplot(melt(bestan_df), aes(x=value)) +
        stat_bin(aes(y=..ndensity..),
                 col="white", fill="skyblue") +
        labs(x="", y="") +
        facet_wrap(~variable, scales = "free", ncol=3) +
        theme_bw() +
        theme(axis.text.y = element_blank(),
              axis.ticks.y = element_blank())
}
