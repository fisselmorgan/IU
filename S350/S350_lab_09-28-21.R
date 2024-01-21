# Example 1
# X ~ Uniform(0,3)
qunif(p = 0.5, min = 0, max = 3)
#QC
qunif(.6,1,5)

# Example 2
# Y ~ Normal(4, 25)
qnorm(p = 0.7, mean = 4, sd = sqrt(25))
#QC
qnorm(.75,0,1)

qnorm(.75,1,4) - qnorm(.25,1,4)

# Example 4
# W ~ Binomial(20, 0.7)
qbinom(p = 0.5, size = 20, prob = 0.7)
qbinom(p = 0.51, size = 20, prob = 0.7)
qbinom(p = 0.57, size = 20, prob = 0.7)
qbinom(p = 0.6, size = 20, prob = 0.7)

