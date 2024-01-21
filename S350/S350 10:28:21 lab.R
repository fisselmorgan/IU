# Etruscan vs. Italian
data = scan("https://mtrosset.pages.iu.edu/StatInfeR/Data/skulls.dat")
etruscan = data[1:84]
italian = data[85:154]

# These are real data

# Are the assumption of our methods satisfied?
# Are these randomly selected samples? Likely not, but perhaps this won't be relevant in this example
# Similarly, there is no reason to think that the assumption of variablees to be identically distributed 
# is violated

# So, we can proceed

# 1. Experimental unit: A skull (from those times)
# 2. 2 populations: Ancient Etruscan and Italian
#   2b. This is a 2-sample problem 
# 3. 84 units drawn from population 1 (Etruscan) and 70 units drawn from population 2 (Italian)
# 4. Delta = mu_1 - mu_2
# 5. Because the goal was to show that the skull breadth is different for these civilizations,
# the hypotheses will be

# H0: Delta = 0
# H1: Delta != 0

# At this point (before looking at the data) you should determine a significance level of alpha
# alpha = 0.02

xbar = mean(etruscan)
ybar = mean(italian)
s1 = sd(etruscan)
s2 = sd(italian)
n1 = length(etruscan)
n2 = length(italian)

SE = sqrt(s1^2/n1 + s2^2/n2)
Deltahat = xbar - ybar
t.w = (Deltahat - 0)/SE
# 11.96595
nu.hat = (s1^2/n1 + s2^2/n2)^2/((s1^2/n1)^2/(n1-1) + (s2^2/n2)^2/(n2-1))

p.value = 2*(1 - pt(abs(t.w), df = nu.hat)) # abs isn't necessary if the t.w is positive
# 0
# reject null hypothesis

# Given the p-value is very small 
# we reject the null hypothesis
# we can conclude that the average skull breadth for Etruscans
# is different than the average skull breadth for Italians

# let's find the 98% CI for the difference of skull breadth averages
alpha = 1 - 0.98
q = qt(1-alpha/2, df = nu.hat)
q

Deltahat - q*SE
Deltahat + q*SE

# We are 98% confident that the difference of skulls breadths' averages (Etruscan - Italian)
# is between 9.1 and 13.6 millimeter

## Problem for quiz 
# Use bechdel data from package fivethirtyeight

library(fivethirtyeight)
View(bechdel)
pass = subset(bechdel, subset = (binary == "PASS"))
dim(pass)
fail = subset(bechdel, subset = (binary == "FAIL"))
dim(fail)
set.seed(350)
id.pass = sample(1:803, 50, replace = F)
id.fail = sample(1:991, 62, replace = F)

x1 = pass$domgross[id.pass] # domgross of films that pass bechdel test
x2 = pass$budget[id.pass] # budget of films that pass bechdel test
y1 = fail$domgross[id.fail]
y2 = fail$budget[id.fail]
x = x1 - x2 # profit for films that pass
y = y1- y2 # profit for films that fail

# 1. Experimental unit: film
# 2. 2 populations, films that pass (population 1) and fail (population 2) bechdel test
#   2a. 50 from pass, 62 from fail
#   2b. 2-sample problem
# 3. 2 measurements per experimental unit
# 4. Delta = mu_1 - mu_2
# 5. H0: Delta >= 0
#    H1: Delta < 0 

# Let's use alpha = 0.07
alpha = 0.07
# access code is bechdel
xbar = mean(x)
ybar = mean(y)
s1 = sd(x)
s2 = sd(y)
n1 = length(x)
n2 = length(y)

SE = sqrt(s1^2/n1 + s2^2/n2)
Deltahat = xbar - ybar
t.w = (Deltahat - 0)/SE
# 1.217351
nu.hat = (s1^2/n1 + s2^2/n2)^2/((s1^2/n1)^2/(n1-1) + (s2^2/n2)^2/(n2-1))

p.value = 2*(1 - pt(abs(t.w), df = nu.hat))
# 0.2260777
q = qt(1-alpha/2, df = nu.hat)
q

Deltahat - q*SE
Deltahat + q*SE
