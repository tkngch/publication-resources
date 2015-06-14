# Attraction, compromise, and similarity effects

## Article
Noguchi, T., & Stewart, N. (2014). In the attraction, compromise, and similarity effects, alternatives are repeatedly compared in pairs on single dimensions. *Cognition, 132,* 44-56. doi: 10.1016/j.cognition.2014.03.006

The published article is also available at: http://www.sciencedirect.com/science/article/pii/S0010027714000456


## Description
The sqlite3 database contains 4 tables: *instruction*, *choiceset*, *participant* and *trial*. The first two tables, *instruction* and *choiceset*, contain the materials used in the experiment: the *instruction* table records text messages presented at each trial, and the *choiceset* table records values of alternatives. The other two tables, *participant* and *trial*, contain the collected data: the *participant* table records whether participant was enganged in the task, and the *trial* table records participants' responses. The R script shows how to load the collected data onto a single data frame.


## Dependencies
The R script uses the following libraries:
- RSQLite (https://github.com/rstats-db/RSQLite)
- Hmisc (http://biostat.mc.vanderbilt.edu/wiki/Main/Hmisc)
- dplyr (https://github.com/hadley/dplyr)
- tidyr (https://github.com/hadley/tidyr)
- ggplot2 (http://ggplot2.org/)


## LICENSE
The article is licensed under Creative Commons Attribution 3.0. The other files are under Creative Commons Attribution 4.0. If you find the data or the script useful, please cite the above paper in your work.
