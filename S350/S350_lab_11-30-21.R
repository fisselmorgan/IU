#####################################################################
# Example: Old Faithful Geyser Data
#####################################################################

# This example was also presented before the break (see 11/18/21 lab)

summary(faithful)
m1 <- lm(waiting ~ eruptions, data = faithful)
plot(waiting ~ eruptions, data = faithful)
abline(m1, col= " red")
summary(m1)

# To change the coordinate ranges in plots we can add to the plot function
# arguments "xlim = c( , )" and "ylim = c( , )" with the appropriate
# coordinate values. 
# As an illustration, to include the origin on our example:
plot(waiting ~ eruptions, data = faithful,
     xlim = c(0,6), ylim = c(0,100))

# Claim: intercept of mean function > 31
# H0 > 31
# H1 < 31
B0 = 33.4744 # y intercept
B1 = 10.7296 # eruptions
se = 1.1549
t = (B0 - 31)/se
1 - pt(t, 270)
# Accept the Null
