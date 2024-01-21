group1 = subset(x = stereograms, subset = (group == 1))
group2 = subset(x = stereograms, subset = (group == 2))

time1 = group1$time
time2 = group2$time

# Install and call an R package
# Let's use the package Faraway
install.packages('faraway')
library(faraway)
data()

View(beetles)
