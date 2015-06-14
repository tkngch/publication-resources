#!/usr/bin/env Rscript

# This script produces a plot similar to Figure 5 in the article.  For more
# information, please visit https://github.com/tkngch/publication-resources

# The relevant article is:
# Noguchi, T., & Stewart, N. (2014). In the attraction, compromise, and
# similarity effects, alternatives are repeatedly compared in pairs on single
# dimensions. Cognition, 132, 44-56. doi: 10.1016/j.cognition.2014.03.006


library(RSQLite)
library(Hmisc)
library(dplyr)
library(tidyr)
library(ggplot2)


###################################
# read the data into a data frame #
###################################

conn <- dbConnect(dbDriver("SQLite"), "data.sqlite3")
data <- dbGetQuery(conn,
                   "
    SELECT
        p.participant_id AS participant_id,
        p.engaged AS engaged,
        t.trial_number AS trial_number,
        t.eye_tracked AS eye_tracked,
        t.choice_type AS choice_type,
        t.third_alternative AS third_alternative,
        t.choice AS choice

    FROM trial AS t

    JOIN participant AS p
        ON t.participant_id IS p.participant_id
                   ")
dbDisconnect(conn)

# filter out screening trials
data <- filter(data, choice_type %in% c("attraction", "compromise", "similarity"))

# filter out non-engaged participants
data <- filter(data, engaged == "yes")


######################################
# Produce a plot similar to Figure 5 #
######################################

d <- data %>%
    mutate(choice_type = capitalize(choice_type)) %>%
    group_by(participant_id, choice_type, third_alternative) %>%
    summarize(A = mean(choice == "A"), B = mean(choice == "B")) %>%
    mutate(third = 1 - (A + B)) %>%
    gather(alternative, proportion, A, B, third) %>%
    mutate(alternative = ifelse(alternative == "third", third_alternative, as.character(alternative))) %>%
    group_by(choice_type, third_alternative, alternative) %>%
    summarize(mean_proportion = mean(proportion),
              interval = qnorm(0.975) * sd(proportion) / sqrt(length(proportion))) %>%
    mutate(favored = ifelse(third_alternative %in% c("Da", "Ca", "Sa"), "A", "B")) %>%
    mutate(alternative = factor(alternative, levels=c("Da", "Ca", "Sa", "A", "B", "Db", "Cb", "Sb")))

plot <- ggplot(d, aes(x=alternative, y=mean_proportion,
                      ymin=mean_proportion - interval,
                      ymax=mean_proportion + interval,
                      group=favored, color=favored)) +
    geom_line(position=position_dodge(0.2)) +
    geom_pointrange(position=position_dodge(0.2)) +
    facet_wrap(~ choice_type, scale="free_x") +
    scale_y_continuous(breaks=c(0.0, 0.3, 0.6), labels=c("0.0", ".3", ".6")) +
    xlab("Alternative") +
    ylab("Choice Proportion") +
    theme(legend.position="none")

dev.new(width=8, height=2.5)
print(plot)
