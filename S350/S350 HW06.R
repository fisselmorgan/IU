# Question 1
# a) Find E[X] 
lilx = c(2,4,12)
prob = c(.3,.5,.2)
EX = sum(lilx * prob)
EX # this EX is different than the EX in c)

# b) Find Var[X]
VarX = sum(lilx^2*prob) - EX^2
VarX

# c) What is the expected value of X?
# Ans:
# The expected value of the sample mean is n * mu, mu is the mean.
# EX = n * mu

# d) What is the variance of X? 
# Ans:
# The variance of the sample is n * sigma^2. sigma^2 is VarX.
# VarX = sigma^2/n

# e) n = 200 : P(X > 5.1) : Probability that the sample mean is greater than 5.1
n = 200
EXbar = n * EX
sigma = sqrt(VarX/n)
Z1 = (5.1-EX)/sigma/sqrt(n)
pnorm(q = .5,mean = EXbar,sd = Z1*(sigma/sqrt(n)))
# I give up, I really don't know how to do this.


#sigma = sqrt(VarX/n)
#mu = n*EX
#(5.1 - mu) / sigma

#xbar = n * EX
#SD = sqrt(VarX / n)
#(5.1 - EX) / SD
# 1 - pnorm(q = ,mean = .1,sd = SD)

# Question 2
mu1 = 350
mu2 = 349
sd1 = 1
sd2 = 1
n1 = 36
n2 = 42
Z = (mu1 - mu2)/sqrt((sd1^2/n1) + (sd2^2/n2))
1 - pnorm(q = .5,mean = 0,sd = Z*sd1)
# 0.4547916 
# Pretty sure this is wrong too
