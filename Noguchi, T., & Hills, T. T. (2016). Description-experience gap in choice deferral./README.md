# The description-experience gap in choice deferral

## Article

Noguchi, T., & Hills, T. T. (2016). Description-experience gap in choice deferral. *Decision, 3,* 54-61.

The publisher's licence does not allow the article to be freely available online. If you are interested in obtaining a copy, please e-mail me.


## Description

The data are organized in four tables: *participant*, which records setsize condition (2 or 35), paradigm (description or sampling) and also participants' age and gender; *alternative*, which records all the generated alternatives (see below); *sampling*, which records alternatives participants clicked; and *choice*, which records branch condition, whether participant deferred or purchased a choice, and if a choice is purchased, the pay-off earned from the purchase.

The R script shows how to load the collected data onto a data frame and make a figure similar to Figure 2 in the article.


### A note on *alternative* table
The structure may be a little confusing. See the first 10 rows from this table below.

alternative_id | branch_id | probability | payoff
---------------|-----------|-------------|-------
00000          | 0         | 0.4         | 1.65
00000          | 1         | 0.6         | 0.0
00001          | 0         | 0.8         | 1.17
00001          | 1         | 0.2         | 0.0
00010          | 0         | 0.04        | 25.08
00010          | 1         | 0.49        | 1.47
00010          | 2         | 0.33        | 0.8
00010          | 3         | 0.13        | 0.0
00011          | 0         | 0.26        | 0.91
00011          | 1         | 0.02        | 32.14

The first two rows, where alternative_id is 00000, show two branches of this alternative: the first branch is 0.4 chance of 1.65 (the first row), and the second is 0.6 chance of 0.0 (the second row). The four rows, where alternative_id is 00010, show four branches of another alternative: the first branch is 0.04 chance of 25.08, the second is 0.49 chance of 1.47, the third is 0.33 chance of 0.8, and the fourth is 0.13 chance of 0.0.

Please note that the branch_id column is 0-indexed: The first branch is where branch_id is 0, the second branch is where branch_id is 1, and so on.

If anything is unclear, please let me know.


## Dependencies

The R script uses the following libraries:
- RSQLite (https://github.com/rstats-db/RSQLite)
- dplyr (https://github.com/hadley/dplyr)
- ggplot2 (http://ggplot2.org/)


## LICENSE

Creative Commons Attribution 4.0.
You may copy, distribute, display and perform the work and make derivative works based on it, only if you give the authors the credits by citing the above paper in your work.
