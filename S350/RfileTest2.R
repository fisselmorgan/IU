install.packages("fivethirtyeight")
library(fivethirtyeight)
View(congress_age)
age = congress_age$age
##
xbar = mean(x)
ybar = mean(y)
s1 = sd(x)
s2 = sd(y)
n1 = 12
n2 = 12
SE = sqrt(s1^2/n1+s2^2/n2)
t.w = (ubar-vbar)/SE
nu.hat = (s1^2/n1+s2^2/n2)^2/((s1^2/n1)^2/(n1-1) + (s2^2/n2)^2/(n2-1))
t.w
pt(abs(t.w), nu.hat)

# Question 1
# 1a)
cal = c(2823, 2822, 2864, 2748, 2844, 2905, 2749, 2835, 2797, 2770, 2756, 2738, 2787, 2831, 2786, 2713, 2735, 2885, 2806, 2744, 2782, 2788, 2810, 2765, 2775, 2779, 2785, 2764, 2702, 2835)
plugin_mean = mean(cal)
# 2790.767
plugin_var = mean(cal^2) - mean(cal)^2
# 2248.579
quantile(cal, 0.5)
# 2785.5
IQR(cal)
quantile(cal, 0.75) - quantile(cal, 0.25)
# 64.75

# 1b)
hist(cal)
plot(density(cal))
qqnorm(cal)
qqline(cal)
# boxplot(cal)
# length(cal)

# 1c)
# H0: mu < 2800
# H1: mu >= 2800

# 1d)
xbar = mean(cal)
mu0 = 2800
sigma = sqrt(plugin_var)
n = length(cal)
t.test = (xbar-mu0)/(sigma/sqrt(n))
# -1.06651
pnorm(t.test)
# 0.1430965
# because the p-value is relatively large, we cannot reject the null as it seems 
# we must accept the null hypothesis (mu < 2800cals)

# 1e)
alpha = 0.03
q = qnorm(1-alpha/2)
xbar - q*sigma/sqrt(n)
# 2771.979
xbar + q*sigma/sqrt(n)
# 2809.554
# our mu0 of 2800cals is included in this interval, 
# so we can say that we 97% confident in the method/procedure we followed

# Question 2
# 2a)
mu = 420
var = 23
sigma = sqrt(var)
set.seed(350)
x = rnorm(n = 92,mean = mu,sd = sigma)
mean(x)
# 419.9088
sd(x)
# 4.541319
1 - pnorm(q = 421,mean = mu, sd = sigma)
#hist(x)
# 0.4174137

# 2b)
mu2 = 418
var2 = 16
sigma2 = sqrt(var)
set.seed(350)
y = rnorm(n = 72,mean = mu2,sd = sigma2)
mean(y)
# 417.598
sd(y)
# 4.60934
pnorm(q = 417, mean = mu2, sd = sigma2)
#hist(y)

# 2c)
pnorm(mean(x)>mean(y))

# Question 3
# 3a)
install.packages('fivethirtyeight')
library(fivethirtyeight)
View(fandango)
rt_norm = fandango$rt_norm
rt_user_norm = fandango$rt_user_norm
rtdif = rt_user_norm - rt_norm
# 3b)
metacritic_norm = fandango$metacritic_norm
metacritic_user_nom = fandango$metacritic_user_nom
metadif = metacritic_user_nom - metacritic_norm
# 3c)
xbar = mean(rt_user_norm) - mean(rt_norm)
ybar = mean(metacritic_user_nom) - mean(metacritic_norm)
s1 = sd(rtdif)
s2 = sd(metadif)
n1 = 146
n2 = 146
SE = sqrt(s1^2/n1+s2^2/n2)
t.w = (xbar-ybar)/SE
# 1.707144
nu.hat = (s1^2/n1+s2^2/n2)^2/((s1^2/n1)^2/(n1-1) + (s2^2/n2)^2/(n2-1))
1-pt(abs(t.w), nu.hat)
# 0.04496524

# 3e)
alpha = 0.05
q = qnorm(1-alpha/2)
