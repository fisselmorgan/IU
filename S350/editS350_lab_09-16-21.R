# Normal distribution

?dnorm

curve(dnorm(x), from = -4, to = 4) # pdf of standard normal



# Example 5.4a
# X ~ Normal(1,4)
# this is a normal with expected value(or mean) of 1 
# and variance (sigma^2 of 4)
# What is P(X <= 3) ?



# A function to shade the normal curve (You do not need to learn this code right now)
# Only learn how to use it
shade.norm <- function(mu = 0, sigma = 1, a = mu  - 4*sigma, b = mu  + 4*sigma){
  curve(dnorm(x, mu, sigma), mu  - 4*sigma, mu  + 4*sigma)
  xvec = seq(mu  - 4*sigma,mu  + 4*sigma, 0.1)
  yvec = dnorm(xvec, mean = mu, sd = sigma)
  polygon(c(xvec[xvec >= a & xvec <=b], b, a), 
          c(yvec[xvec >= a & xvec <=b], 0, 0), col = "lightgray")
}

# We can now use our function
shade.norm()
shade.norm(a = 2, b=3)

# what is P(X <= 3)
shade.norm(mu = 1, sigma = sqrt(4), b = 3)


pnorm(3, 1, sd = sqrt(4)) # F(3) = P(X<=3)

z = (3 - 1)/sqrt(4)
pnorm(z)


# X ~ Normal(1,4)
# What is P(2 <= X <= 3) ?

shade.norm(mu = 1, sigma = sqrt(4), a = 2, b = 3)

pnorm(3, 1, 2) - pnorm(2, 1, 2)

# what is the P(X > 3.5)?

shade.norm(mu = 1, sigma = sqrt(4), a = 3.5)
# P(X > 3.5) = 1 - P(X <= 3.5)
1 - pnorm(3.5, 1, 2)

# Area between (-1,1),(-2,2),(-3,3)

shade.norm(a = -2, b = 2)

pnorm(c(-2,2))
#find the difference 

# F(2) - F(-2)

pnorm(2) - pnorm(-2)

pnorm(c(1,2,3)) - pnorm(c(-1,-2,-3))

# A few more things with the normal 

?pnorm
#qnorm input Area (quartiles)
#rnorm() produces a sample of random values from 
#a normal distribution

rnorm(10)

#HW04 Q4:

shade.norm(mu = 4, sigma = sqrt(9))

#HW04 Q5:
shade.norm(mu = 69.2, sigma = 2.5)
1 - pnorm(72, 69.2, 2.5)

1 -pnorm(72, 69.2,2.5) * pnorm(72,63.8,2.7)

pnorm(69.2, 69.2,2.5) 

shade.norm(5.4,sqrt(13.54))
pnorm(0,5.4,13.54)
