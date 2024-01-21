# Question 1
# 10.5 Problem Set D 1&2 
# 1)
data = c(0.693, 0.662, 0.690, 0.606, 0.570,0.749, 0.672, 0.628, 0.609, 0.844,0.654, 0.615, 0.668, 0.601, 0.576,0.670, 0.606 ,0.611, 0.553, 0.933)
plot(density(data))
plot(density(log(data)))
# Assumption of normality is more plausible with the log graph
# because its a more smooth curve than the other graph
# thus a more normal distribution

# 2)
# H0: Using golden ratio
# H1: Not using golden ratio
t.test(log(data), mu = 0.618034)
# p-value < 2.2e-16, therefore we reject the H0 and accept H1
# t = -36.169

# Question 2
# 11.4 Problem Set D 1,2,3,4
# 1)
normal = as.vector(c(4.1, 6.3, 7.8, 8.5, 8.9, 10.4, 11.5, 12.0, 13.8, 17.6, 24.3, 37.2))
diabetic = as.vector(c(11.5, 12.1, 16.1, 17.8, 24.0, 28.8, 33.9, 40.7, 51.3, 56.2, 61.7, 69.2))

plot(density(normal))
lines(density(diabetic))
# The distributions don't seem to be symmetric

# 2)
# square root 
plot(density(sqrt(normal)))
lines(density(sqrt(diabetic)))
# log
plot(density(log(normal)))
lines(density(log(diabetic)))
# log(normal) is likely from a symmetric distribution
# I would prefer the log transformation

# 3)
plot(density(log(diabetic)))
plot(density(log(normal)))
# The log of diabetic is more normal than it was but still seems to be bimodal
# The mean of diabetic patients is higher than the mean of the normal patients
# This shows that diabetic patients seem to excrete more β-thromboglobulin than normal patients

# Question 3 
# ISIR 13.4 Question 9
crime = matrix(c(50,43,88,62,155,110,379,300,18,14), ncol=2, byrow=TRUE)
colnames(crime) = c('drink','abstain')
View(crime)

exp.val = function(x){
  n = sum(x)
  n.row = apply(X=x,MARGIN=1,FUN=sum)
  n.col = apply(X=x, MARGIN = 2, FUN = sum)
  expected = outer(X=n.row,Y = n.col)/n
  expected
}
exp = exp.val(crime)
G2 = sum((crime - exp)^2/exp)
1-pchisq(G2,df=8)
# 0.9973544
# p-value is quite large, we cannot accept that crime and drinking are related
# they may be independent

# Question 4
# a)
data("Sahlins")
View(Sahlins)
plot(acres~consumers,data=Sahlins)
# There doesn't seem to be a relationship in the scatterplot

# b) 
m1 = lm(acres~consumers, data = Sahlins)
summary(m1)
plot(acres~consumers, data = Sahlins)
abline(m1, col = 'red')
# The slope does not seem to be significant so we can call it 0
# the intercept is greater than 0, so we are in primitive communism.

#c)
Sah = Sahlins[-(4),]
plot(acres~consumers,data=Sah)
m2 = lm(acres~consumers, data = Sah)
summary(m2)
plot(acres~consumers, data = Sah)
abline(m2, col = 'red')
# Slope: 0.72 
# this is significant we could be in a capitalist society now
# The second plot we created better explains the relationship with an r-squared: ~32.6% 

#d)
# with the 4th house our r-squared was ~14.1%
predict(m1,newdata = data.frame(consumers=1.5),interval = "prediction",level = .98)
#       fit      lwr      upr
#    2.150125 0.961766 3.338483
# 2.15 acres per gardener
