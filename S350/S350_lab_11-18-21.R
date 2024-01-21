#####################################################################
# Example Mothers and Daughters
#####################################################################

Heights = read.table("Heights 2.txt",header = T)
summary(Heights)
View(Heights)
dim(Heights)
head(Heights)

# A scatterplot
# The predictor (X) on the x-axis and the response (Y) on the y-axis
# Write your model Y ~ X in R
plot(dheight ~ mheight, data = Heights, cex = 0.2)


# A conditional random variable illustration
# Observe the variation for each unit of X
# We use a whole inch in width to show enough variation
# In theory, it would be just one given value X=x

attach(Heights)
sel = (57.5 < mheight) & (mheight <= 58.5) |
  (62.5 < mheight) & (mheight <= 63.5) |
  (67.5 < mheight) & (mheight <= 68.5)

plot(dheight ~ mheight, data=Heights, subset=sel)
detach(Heights)
# The variation of the response for a given value of the regressor
# is our random variable Y|X=x



###############################################################
# Is a line a good representation of the relationship 
# between X and Y?
# Let's compare a line with a local mean function (nonparametric)

# YOU DO NOT NEED TO LEARN THE CODE FOR THE LOCAL MEAN
# First we create a function to find the mean 
local.mean = function(val,x, y, delta = 0.5){
  width = which(x>(val - delta) & x<(val+delta))
  mean(y[width])
}
mh.list = seq(55, 70, 0.5)
dh.list = rep(NA, length(mh.list))
for(j in 1:length(mh.list)){
  dh.list[j] = local.mean(val = mh.list[j], x = Heights$mheight,
                          y = Heights$dheight)
}

# Now we plot our data and added the local mean line in blue
plot(dheight ~ mheight, Heights)
lines(mh.list, dh.list, col="blue")

# Let's also add the line that best represents 
# the relationship in red
m1 = lm(dheight ~ mheight, Heights)
abline(m1, col = "red")



#####################################################################
# Simulation for regression lines
# 1. We keep the predictor values (Xs) the same
# 2. We keep the mean function the same
# 3. Only the error terms and the responses change
#    We assume they follow a normal distribution
# 4. We obtain the regression lines for each replication
#    and plot them together for comparison
# 5. We finally add the true line (mean function) for comparison
#####################################################################

beta0 = 1
beta1 = .5 
sigma_2 = 100
n = 20 
set.seed(350) 
x = sample(50:100, n, replace = TRUE) 
repli <- 5
betahat.df <-  data.frame(intercept = NA, slope = NA, rep = as.character(1:repli))
for (j in 1:repli){
  e.j = rnorm(n, mean = 0, sd = sqrt(sigma_2))
  y.j = beta0+beta1*x+e.j
  betahat.df[j,c(1,2)] = coef(lm(y.j~x))
  plot(y.j ~ x, xlim = c(0,110), ylim = c(-20,80))
  for (k in 1:j){
    abline(a = betahat.df[k,1], b = betahat.df[k,2], col =k)
  }
  readline(prompt="Press [enter] to continue")
}

# The true mean function:
abline(a = 1, b = .5, col = "red", lwd=3)


#####################################################################
# Example: Old Faithful Geyser Data
#####################################################################

# If interested, visit
# https://www.nps.gov/yell/planyourvisit/geyser-activity.htm
#

summary(faithful)
m1 <- lm(waiting ~ eruptions, data = faithful)
plot(waiting ~ eruptions, data = faithful)
abline(m1, col= " red")
summary(m1)

