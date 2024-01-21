# Lab 9-30-21
# TOC
# 1. Vectors
# 2. Plug-in estimates
# 3. Plots
# 4. Working with data
# 5. Simulations



#################################################################
# 1. Vectors
# In R, vectors are sequence of elements of the same type

# Create your own vectors with function "c()"

c(1, 2, 5)
vec1 = c(2, 4, 6, 8, 10)

1:3 # using ":"
31:40
vec2 = 1:5

#################################################################
# 2. Plug-in Estimates
vec = 1:10
mean(vec)# mean(): the mean or sample average
median(vec)# median(): median, 2nd quartile, or 0.5-quantile
quantile(vec)# The 5-number summary
quantile(vec, probs = 0.25) #q1 or 0.25-quantile
#the probs argument corresponds to alpha value from  notes
summary(vec) # 5-number summary plus the mean
IQR(vec) # IQR
var.vec = mean((vec - mean(vec))^2) #Plug in estimate for Variance
var(vec) #this is not the same as the plug-in estimate for variance
sqrt(var.vec)#plug in estimate for Standard Deviation
mean(vec^2) - mean(vec)^2 # alt. formula
sqrt(var.vec) # Standard Deviation


# Empirical CDF
plot(ecdf(vec))

EF = ecdf(vec)
EF(6)

#################################################################
# 3. Plots
hist(vec) # histogram
plot(density(vec)) # kernel density estimate
boxplot(vec) # boxplot (five number summary as picture)

qqnorm(vec) # Normal probability or QQ plot  (quantile to quantile)
qqline(vec)


# Exercise 1: 
# a. Create a vector of 10 numbers of your choice
my_vec = c(0, 1, 2, 4, 6, 9, 14, 20, 99, 100)
# b. Find the plug-in estimates for mean, median, IQR, and std. deviation
mean(my_vec)
median(my_vec)
mean((my_vec - mean(my_vec))^2)


#################################################################
# 4. Working with data

# 4.1. Uploading data from file

rm(list = ls()) #clear your global environment from any object

getwd() # Provides the current working directory

# If your data file is stored in the same places as your Rscript file
# you do not need to add other paths
ht = scan("heights.txt") #this reads your vector
ht
head(ht) #show you the first 6 elements

# Exercise 2: Find the plug-in estimates for the mean, median, IQR, and std. deviation.
mean(ht)
median(ht)
quantile(ht,probs= .75) - quatile(ht,probs=.25)
IQR(ht)

# 4.2. Uploading data from internet
# https://mtrosset.pages.iu.edu/StatInfeR/Data/sample774.dat
sample774 = scan("https://mtrosset.pages.iu.edu/StatInfeR/Data/sample774.dat")

# Exercise 3: Obtain the histogram, boxplot, QQ-plot, and kernel density plot for ht
# for sample774
hist(sample774)
qqnorm(sample774)
qqline(sample774)
# 4.3. Generate your own data
# 4.3a. Using the pseudo-random generation function for some distributions
set.seed(10)
rnorm(30)
rnorm(30, mean = 10, sd = 2)
runif(20)
rbinom(25, size = 10, prob = 0.3)

# Exercise 4: Create a vector called "norm.vec" that contains 15 
# observations form a random variable with mean 23 and variance 9

norm.vec = rnorm(15, mean=23, sd=sqrt(9))
norm.vec

# 4.3b. A random sample from a vector
big.vector = 1:10000
sample(x = big.vector, size = 10, replace = T)
set.seed(10) # seed to replicate the random sample
sample(x = big.vector, size = 10, replace = T)


# Exercise 5: Create a vector called "my.vec" that  contains 15
# observation (with replacement) form big.vector


###########################################
# 5. Simulations

my.vec = 1:20

# We find the average of 30 numbers samples from my.vec
mean(sample(my.vec,30,replace = T))

# Let's replicate this 15 times
replicate(n = 15,expr = mean(sample(my.vec,30,replace = T)))

# We can store this average in a single vector
mean.vec = replicate(n = 15,expr = mean(sample(my.vec,30,replace = T)))
mean.vec


# Exercise 6: Obtain a simulation with 30 replications, each as the average of
# 100 observations from my.vec.
