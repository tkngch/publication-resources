#!/usr/bin/env Rscript


library(dplyr)
library(tidyr)
library(ggplot2)
library(scales)
library(lme4)


data <- read.csv("./data.csv")
data$year <- as.factor(data$year)


# figure 3
d <- data %>%
    gather(measure, score, future_focus, past_focus, future_horizon, past_horizon) %>%
    mutate(measure = factor(measure))
levels(d$measure) <- c("Future Focus", "Past Focus", "Future Horizon", "Past Horizon")

plot <- ggplot(d, aes(x=score, y=gdp, color=year)) +
    geom_point() +
    facet_wrap(~ measure) +
    scale_x_continuous(breaks=c(0.0, 0.5, 1.0), labels=c("0.0", ".5", "1.0")) +
    scale_y_log10(breaks = c(10^3, 10^4, 10^5),
                  labels = c(expression(10^3), expression(10^4), expression(10^5))) +
    xlab("Score") +
    ylab("Per-capita GDP (USD)") +
    theme(legend.title=element_blank())

# ggsave("./figure.png", plot, width=6, height=5.0)
dev.new(width=6, height=5.0)
print(plot)


# main analysis
## results may slightly vary, depending on lme4 versions.
fm <- lmer(log(gdp) ~ future_focus + past_focus + future_horizon + past_horizon
                        + (1 | year) + (0 + future_focus | year) + (0 + past_focus | year)
                        + (0 + future_horizon | year) + (0 + past_horizon | year),
           data=data, REML=FALSE)
anova(fm, update(fm, .~. - future_focus), test="Chisq")
anova(fm, update(fm, .~. - past_focus), test="Chisq")
anova(fm, update(fm, .~. - future_horizon), test="Chisq")
anova(fm, update(fm, .~. - past_horizon), test="Chisq")
