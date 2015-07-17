# Set size effects on the description-experience gap

## Article
Noguchi, T., & Hills, T. T. (2015). Experience-based decisions in large set sizes favor riskier alternatives. *Journal of Behavioral Decision Making*. doi: 10.1002/bdm.1893

The publisher's licence does not allow the article to be freely available online. If you are interested in obtaining a copy, please e-mail me. Alternatively, the article is available at http://onlinelibrary.wiley.com/doi/10.1002/bdm.1893/abstract


## Description
Each sqlite3 database contains the data from one experiment. The data are organized in four tables: *participant*, which records participants' age and gender; *condition*, which records conditions assigned to each participant at each trial; *alternative*, which records all the generated alternatives; and *response*, which records the responses from participants.  The R script shows how to load the collected data onto a data frame and make a figure similar to Figures 3 and 4 in the article.


## Dependencies
The R script uses the following libraries:
- RSQLite (https://github.com/rstats-db/RSQLite)
- dplyr (https://github.com/hadley/dplyr)
- ggplot2 (http://ggplot2.org/)
- lme4 (https://github.com/lme4/lme4)


## LICENSE
Creative Commons Attribution 4.0.
You may copy, distribute, display and perform the work and make derivative works based on it, only if you give the authors the credits by citing the above paper in your work.
