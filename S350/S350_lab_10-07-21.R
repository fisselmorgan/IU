## Function in R

# Sum of two numbers
sum.2 = function(a,b) a + b
sum.2(1,23)

# Plug in variance
plug.var = function(x){
  mean(x^2) - mean(x)^2
}

plug.var(1:5)
var(1:5)

######################
N = 10^5
set.seed(350)
x1 = rbinom(N, 100, .01)
x2 = c(rnorm(N/2,10,3),rnorm(N/2,2,1))
astragali = c(1,3,3,3,3,4,4,4,4,6)
x3 = sample(x = astragali, size = N, replace = TRUE)


#######################################

# Function to illustrate the weak law of large numbers

wlln = function(x, repl, size, epsilon){
  xbar.vec = replicate(repl, mean(sample(x, size, replace = T)))
  lb = mean(x) - epsilon #lower bound
  ub = mean(x) + epsilon #upper bound
  prob=mean(xbar.vec >= lb & xbar.vec <= ub) #empirical probability
  data.frame(n = size, probability = round(prob,2))
}

wlln(x = x1, repl = 10,size = 1000, epsilon = 0.1)


# 3. The Central Limit Theorem, CLT
###################################

clt = function(x, num.samples, n){
  xbar.vec = replicate(num.samples, mean(sample(x,n, replace = T)))
  sigma2 = mean(xbar.vec^2)-(mean(xbar.vec))^2
  sigma = sqrt(sigma2)
  sigma.X = sqrt(mean(x^2) - mean(x)^2)
  print(c(mu.X = mean(x), 
          mu.Xbar = mean(xbar.vec), 
          sigma.X = sigma.X, 
          sigma.Xbar = sigma))
  hist(xbar.vec, breaks = 100, 
       xlim = c(min(x),max(x)), 
       main = paste("n =", n),
       xlab = paste("Sample mean (Xbar_n)"))
}

clt(x = x2, num.samples = 10^5, n = 100)
