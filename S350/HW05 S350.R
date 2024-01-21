#Problem 1: EX,median, IQR, .99 quantile, and P(1.5 < X < 2.5)
#a)

#Problem 2: X ~ Uniform(0,10) mean = 5, var = 25/3
#a) iqr/sd
q3 = qunif(.75,0,10)
q1 = qunif(.25,0,10)
iqr = q3 - q1
sd = sqrt(25/3)
iqr/sd
#  1.732051
#b) Y ~ Normal mean = 5, variance = 25/3
# iqr/sd?
q3 = qnorm(.75,5,sqrt(25/3))
q1 = qnorm(.25,5,sqrt(25/3))
iqr = q3 -q1
sd = sqrt(25/3)
iqr/sd
# 1.34898

#Problem 3:
samplePulse = scan("https://mtrosset.pages.iu.edu/StatInfeR/Data/pulses.dat")
#a)
plot(ecdf(samplePulse))

#b)
mean = mean(samplePulse)
mean
# 70.30769
variance = mean((samplePulse - mean(samplePulse))^2)
variance
# 87.90533
median = median(samplePulse)
median
# 72
iqr = IQR(samplePulse)
iqr
# 12
sd = sqrt(variance)
iqr/sd
# 1.279893

#c)
#Histogram
hist(samplePulse)
#Boxplot
boxplot(samplePulse)
#Kernel Density Estimate
plot(density(samplePulse))

#Problem 4:
#a)
urn = c(2,2,2,2,2,5,5,10,10,10)

#b)
set.seed(350) 
sum(sample(50,10,T))

#c)
my.big.vec = replicate(1000,sum(sample(50,10,T)))
#d)
hist(my.big.vec)
qqnorm(my.big.vec)
plot(density(my.big.vec))
