# Q2 (ISIR 9.6.4) 
# c)
mu = 23
xbar = 22.8
s = 3
n = 225
t = (xbar-mu)/(s/sqrt(n))
t
# -1

# d)
#1 - 2 * pnorm(-abs(t))
1 - pt(t, df = n-1)
# 0.8408052 > 0.05 = alpha

# Q3
# a)
install.packages("nycflights13")
library("nycflights13")
?flights
# dep_delay = pop of interest
dd = flights$dep_delay
dd = na.omit(dd)
# b)
hist(x = dd)
qqplot(qqnorm(dd),qqline(dd))
# It does not appear to be a normal distribution, it is right-skewed.

# c)
set.seed(350)
n = 200
sampl = sample(na.omit(dd), n, F)
# test that avg dept time is 50 minutes mu = 50
xbar = mean(sampl)
xbar
# 19.915 Average departure time is actually closer to 20 minutes.

# Q4
# d) 
n = 1000
mu = 20
xbar = 40
p = 0.02
s = sqrt(n*p*(1-p))
z = (xbar - mu)/(s/sqrt(n))
z
# 142.8571


# Q5
# b)
n = 20
xbar = 13
mu = 10
p = 0.5
s = sqrt(n*p*(1-p))
z = (xbar - mu)/(s/sqrt(n))
pbinom(q = xbar,size = n,prob = p)
# p-value = 0.9423409

# c)
n = 20
xbar = 18
mu = 10
p = 0.5
s = sqrt(n*p*(1-p))
z = (xbar - mu)/(s/sqrt(n))
pbinom(q = xbar,size = n,prob = p)
# 0.99998

