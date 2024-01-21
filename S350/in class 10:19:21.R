# Exercise: Bechdel

# H0: mu >= 70000000
# H1: mu < 70000000

# Because tthe alternative hypothesis inequality  is "less than"
# this is a left-tailed test
# (p-value: we find an area under the curve to the left of the test statistic)

library("fivethirtyeight")
dg = na.omit(bechdel$domgross)
length(dg)

set.seed(350)
n = 300
x_sample = sample(dg, n, F)
hist(x_sample)
qqnorm(x_sample)
qqline(x_sample)
# def not a normal distribution right-skewed

# variance unknown
xbar = mean(x_sample)
s = sd(x_sample) # sqrt(var(x_sample))
SE = s/sqrt(n)
t.stat = (xbar - 70000000)/SE
t.stat
p.value = pt(t.stat, df = n - 1) # pt because var unknown we are estimating it
p.value # probability of getting a test statistic


SE = 3/sqrt(25)
t.stat = (1-0)/SE
t.stat
p.value = 1-pnorm(t.stat)
p.value


n = 100
rep = 600
p = .5