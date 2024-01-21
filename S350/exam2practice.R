# Q1
# a)
install.packages("fivethirtyeight")
library(fivethirtyeight)
View(congress_age)
age = congress_age$age
hist(age)
plot(density(age))
plugin_mean = mean(age) # sum(age)/length(age)
plugin_var = mean(age^2) - mean(age)^2
plugin_median = quantile(age, 0.5)
boxplot(age)
iqr = IQR(age)
iqr/sqrt(plugin_var)
qqnorm(age)
qqline(age)
# b) 
# Likely from a normal distribution, the qqline closely follows the qqnorm 
# and the boxplot seems to be in the center, but the data is slightly right 
# skewed
# c) 
# P(35 <= X <= 45)
# since it not really normal, we must use logical operators
mean(age >= 35 & age <= 45)
# about 21%


