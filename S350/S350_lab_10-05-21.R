### Plots

## Sample of size n drawn from a normal distribution

n = 30
v1 = rnorm(n)
op <- par(mfrow = c(2,2)) # Code to create output 2 X 2
boxplot(v1)
hist(v1)
plot(density(v1))
qqnorm(v1); qqline(v1)
par(op) # Return graphic parameters to default version

# Recognizing when sample of size n is drawn from a normal distribution

n = 10
op <- par(mfrow = c(2,2))
qqnorm(rnorm(n))
qqnorm(runif(n))
qqnorm(rbinom(n, 100, 0.1))
qqnorm(rchisq(n, 5))
par(op)

## Review: Mean and Variance of Sums of RVs

## Example: X1, X2, ..., Xn ~ P with EXi = mu, VarXi = sigma^2
## Y = sum(X1, X2, ..., Xn)
## Xbar = mean(X1, X2, ..., Xn)





vec1 = rbinom(10^5, 100, 0.01) # X ~ binomial(n=100, p = 0.01)
hist(vec1, breaks = 5)
plot(density(vec1))
qqnorm(vec1)
qqline(vec1)

mean(vec1) # EX = np = 1
mean(vec1^2) - mean(vec1)^2 # VarX = np(p-1) = 100*0.01*0.99 = 0.99

# Let's take the sum of samples of size n

n = 30
sam.n = replicate(10^5, mean(sample(vec1,n,T)))
hist(sam.n, freq = F)
curve(dnorm(x, n, sqrt(n*0.99)), add = T, col="red")


# Matrices

A = matrix(data = 1:9, nrow = 3, ncol = 3)
A

A[1,2]
A[ ,2]
A[1, ]
A[1,2] <- 10
A

#######################################################################
# Logical operators

b = 1:50
b == 4
b >= 25
b > 10 & b < 20
b > 10 | b == 5

sum(b ==4)
mean(b > 10 & b < 20) # proportion of observation with these criteria


#######################################################################
# Data Frames

data()
View(faithful)
v3 = faithful$eruptions
hist(v3)
plot(density(v3))

big.sum.v3 = replicate(10^5, sum(sample(v3,50,T)))
hist(big.sum.v3)
plot(density(big.sum.v3))

# Exercise: Do the same for waiting time