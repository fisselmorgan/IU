# Q1
# a)
pbinom(q=3,size=25,prob=.05)

pbinom(q=2,size=25,prob=.05)

# b)
1 - pbinom(q = 4,size = 25,prob = .05)

# c)
pbinom(3,25,.05)-pbinom(1,25,.05)

# d)
# EX = n*p = 1.25
# VarX =  n*p*(1-p) = 1.1875
# sigma = VarX = sqrt(1.1875)

# e)
pbinom(0,50,0.05)
