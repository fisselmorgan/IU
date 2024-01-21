2 + 3 # this is the sum of 2 and 3

factorial(4)

# Combinations
choose(n = 200, k = 17)
choose(200,17)

# pmf for a Binomial

# f(17)
choose(200,17)*0.9^17*.1^183

# Using the function dbinom
# this is the pmf for a binomial

dbinom(x = 17, size = 200, prob = 0.9)
dbinom(17, 200, 0.9)


### CDF for binomial

# F(17)
# We construct the CDF as the sum of pmf's

dbinom(0, 200, 0.9)
0:5 # the column ":" produces a sequence of numbers as a vector
dbinom(0:17,200, 0.9)
sum(dbinom(0:17,200, 0.9)) # this is F(17)

# In R, the CDF for the binomial
# is given by the function pbinom()
pbinom(q = 17, size = 200, prob = 0.9)
pbinom(17, 200, 0.9)