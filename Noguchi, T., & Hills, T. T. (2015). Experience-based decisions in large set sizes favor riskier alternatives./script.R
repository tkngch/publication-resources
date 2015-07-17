#!/usr/bin/env Rscript

# This script produces a plot similar to Figures 3 and 4 in the article. For
# more information, please visit
# https://github.com/tkngch/publication-resources

# The relevant article is:
# Noguchi, T., & Hills, T. T. (in press). Experience-based decisions in large
# set sizes favor riskier alternatives. Journal of Behavioral Decision Making.


library(RSQLite)
library(dplyr)
library(ggplot2)
library(lme4)


# Uncommenting the second line below will plot and analyse the data from
# Experiment 2.
database <- "./data_exp1.sqlite3"
# database <- "./data_exp2.sqlite3"


###################################
# read the data into a data frame #
###################################

conn <- dbConnect(dbDriver("SQLite"), database)
data <- dbGetQuery(conn,
                   "
SELECT
    r.participant_id,
    c.setsize,
    c.paradigm,
    c.domain,
    c.trial,
    (CASE a.category WHEN 'riskier' THEN 1.0 ELSE 0.0 END) AS riskier_choice
FROM
    response AS r
JOIN
    alternative AS a
    ON r.alternative_id IS a.alternative_id
JOIN
    condition AS c
    ON r.participant_id IS c.participant_id AND r.trial IS c.trial
WHERE
    r.action IS 'choice' AND c.included_in_main_analysis IS 'yes'
                   ")
dbDisconnect(conn)


#############################################
# Produce a plot similar to Figures 3 and 4 #
#############################################

d <- data %>%
    group_by(participant_id, setsize, paradigm, domain) %>%
    summarize(proportion = mean(riskier_choice)) %>%
    group_by(setsize, paradigm, domain) %>%
    summarize(mean_proportion = mean(proportion),
              ci = qnorm(0.975) * sd(proportion) / sqrt(n())) %>%
    mutate(SetSize = factor(ifelse(setsize == 2, "Small", "Large"), levels=c("Small", "Large")),
           Paradigm = paste(toupper(substring(paradigm, 1,1)), substring(paradigm, 2), sep=""),
           Domain = paste(toupper(substring(domain, 1,1)), substring(domain, 2), " Domain", sep=""))

plot <- ggplot(d, aes(x=SetSize, y=mean_proportion,
                      ymin=mean_proportion - ci, ymax=mean_proportion + ci,
                      group=Paradigm, color=Paradigm)) +
    geom_line() +
    geom_pointrange() +
    facet_wrap(~ Domain) +
    xlab("Set Size") +
    ylab("Proportion of Riskier Choice") +
    scale_y_continuous(breaks=c(0.2, 0.4, 0.6, 0.8), labels=c(".2", ".4", ".6", ".8"))

dev.new(width=6, height=3)
print(plot)


############################################
# Analyse the proportion of riskier choice #
############################################

# 3 way interaction between domain, paradigm and setsize
fm <- glmer(riskier_choice ~ domain * paradigm * setsize + (domain | participant_id),
            control=glmerControl(optimizer="bobyqa", optCtrl=list(maxfun=1e8)),
            family=binomial,
            data=data)

anova(fm, update(fm, .~. - setsize : domain : paradigm), test="Chisq")
