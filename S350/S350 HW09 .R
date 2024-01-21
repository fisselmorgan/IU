# Problem Set A
# Question 2
# a) need test statistic
alpha = 0.05

xbar = -0.82
ybar = 1.39
s1 = 4.09
s2 = 1.22
n1 = 10
n2 = 20

SE = sqrt(s1^2/n1 + s2^2/n2)
Deltahat = xbar - ybar
t.w = (Deltahat - 0)/SE
# -1.671927
nu.hat = (s1^2/n1 + s2^2/n2)^2/((s1^2/n1)^2/(n1-1) + (s2^2/n2)^2/(n2-1))

pt(1.76,df=10)

#Problem Set C 
# Question 2
typeA = c(233, 291, 312, 250, 246, 197, 268, 224, 239, 239, 254, 276, 234, 181, 248, 252, 202, 218, 212, 325)
typeB = c(344, 185, 263, 246, 224, 212, 188, 250, 148, 169, 226, 175, 242, 252, 153, 183, 137, 202, 194, 213)
qqnorm(typeA)
qqnorm(typeB)
# Question 3
xbar = mean(typeA)
ybar = mean(typeB)
s1 = sd(typeA)
s2 = sd(typeB)
n1 = length(typeA)
n2 = length(typeB)

SE = sqrt(s1^2/n1 + s2^2/n2)
Deltahat = xbar - ybar
t.w = (Deltahat - 0)/SE
# 2.562113
nu.hat = (s1^2/n1 + s2^2/n2)^2/((s1^2/n1)^2/(n1-1) + (s2^2/n2)^2/(n2-1))

p.value = 2*(1 - pt(abs(t.w), df = nu.hat))
# 0.0148105
# 3a. (should not reject the null)
# 3b. 2 sided confidence interval
alpha = 1 - .9
q = qt(1-alpha/2, df = nu.hat)
q

Deltahat - q*SE
# 11.84155
Deltahat + q*SE
# 57.65845

# Question 4
xbar = 23.4
ybar = 21.9
sd1 = 5.7
sd2 = 7.2
n1 = 235
n2 = 197

SE = sqrt(s1^2/n1 + s2^2/n2)
Deltahat = xbar - ybar
t.w = (Deltahat - 0)/SE
# 0.3578143
# d) H0: delta >= 0
#    H1: delta < 0
# given that delta is > 0, we can determine that an orange background actually makes it easier to read
# we shoud reject H1
nu.hat = (s1^2/n1 + s2^2/n2)^2/((s1^2/n1)^2/(n1-1) + (s2^2/n2)^2/(n2-1))

p.value = 2*(1 - pt(abs(t.w), df = nu.hat))
# 0.7206918

alpha = 1 - .97
q = qt(1-alpha/2, df = nu.hat)
q
# 2.178721
Deltahat - q*SE
# -7.633458
Deltahat + q*SE
# 10.63346 
