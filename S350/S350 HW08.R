# Problem 1 (ISIR 9.6 #9)
sigma = 6
L = 2
q = qnorm(1-(0.01/2))
n = ((2*q*sigma)/L)
n
# 15.45498 They would need ~16 measurements

# Problem 2 (ISIR 9.6 #12)
# i)
pbinom(2,89,.3) + (1 - pbinom(86,89,.3))
# p = 1.240591e-11

# ii)
z = ((2/89) -  0.3) / (sqrt(0.3*0.7)/sqrt(89))
pnorm(z)
# 5.538045e-09,  I  don't think this is a good approximation in this case. 

# Problem 3 Set B #1
# a)
s1 = rnorm(19)
s2 = rnorm(19)
s3 = rnorm(19)
s4 = rnorm(19)
# b)
qqnorm(s1)
qqline(s1)
qqnorm(s2)
qqline(s2)
qqnorm(s3)
qqline(s3)
qqnorm(s4)
qqline(s4)
# c) 
vec = c(1.1402, -1.8658, 0.8520, -1.8251, 0.8530, -0.0589, -1.6554, -1.7599, -1.4330, -1.3853, 2.9794, 2.4919, 2.1601, 2.2670, -0.5479, -0.7164, 0.6462, -0.8365, 1.1997)
sd = sd(vec)
iqr = IQR(vec)
iqr/sd
# 1.590833
# d) 
# It seems that it was drawn from a normal distribution, the lines all follow the plots
# however the sample is kind of small.

# Problem 3 Set B #2
n = 19
q = qt(1-(0.05/2), n-1)
q * (sd/sqrt(n))
# +/- 0.7814062

# Problem 4 Set C #1
# a) experimental units are seedlings
# b) Let Xi denote the height of the seedling i. X1,...,Xn ~ P
# c) H0: q2(P) >= theta
#    H1: q2(p) < theta
# unsure about this last part, not sure how to proceed
