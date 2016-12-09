#!/usr/bin/env Rscript

system("clear")
graphics.off()
rm(list=ls())
# options(warn=1)  # print warnings as they occur
options(warn=2)  # treat warnings as errors

library(RSQLite)
library(dplyr)
library(ggplot2)


db <- src_sqlite("./data.sqlite3")
data_table <- tbl(db, sql("

SELECT
    ch.participant_id,
    pa.paradigm,
    pa.setsize,
    ch.branch_condition,
    AVG(CASE ch.choice WHEN 'purchase' THEN 1.0 ELSE 0.0 END) AS proportion_purchase

FROM
    choice AS ch

JOIN
    participant AS pa
    ON pa.participant_id IS ch.participant_id

GROUP BY
    ch.participant_id, pa.paradigm, pa.setsize, ch.branch_condition

"))


data <- data_table %>% collect %>%
    mutate(paradigm = as.factor(paradigm),
           setsize = as.factor(setsize),
           branch_condition = as.factor(branch_condition)) %>%
    group_by(paradigm, setsize, branch_condition) %>%
    summarize(mean_proportion_purchase = mean(proportion_purchase),
              ci = qnorm(0.975) * sd(proportion_purchase) / sqrt(n()))

plot <- ggplot(data, aes(x=setsize, y=mean_proportion_purchase,
                         ymin=mean_proportion_purchase - ci,
                         ymax=mean_proportion_purchase + ci,
                         group=branch_condition, color=branch_condition)) +
    geom_line() +
    geom_pointrange() +
    facet_wrap(~ paradigm) +
    xlab("Set size") +
    ylab("Proportion of Choice Purchase") +
    scale_color_discrete(name="Branches")

dev.new(width=6, height=3)
print(plot)
