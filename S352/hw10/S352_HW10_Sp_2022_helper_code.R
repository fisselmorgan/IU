#binomial - Q2a
library(boot)
data(nodal)
y = nodal$stage

#poisson - Q2b
library(boot)
data(fir)
y = fir$count

#gamma - Q2c
library(boot)
data(poisons)
y = poisons$time
shape = 4.31 #use fixed shape

#gaussian - Q2d
library(boot)
data(acme)
y=acme$acme

#lin mod - Q2e
library(palmerpenguins)
data("penguins")
y = penguins$flipper_length_mm
x = penguins$body_mass_g
ind = !(is.na(y)|is.na(x))
y = y[ind]
x = x[ind]

##
## rinvgamma definition for problems 2d and 2e
## simple Inverting of draws from appropriate gamma distribution
## parameterized using shape = delta and scale = zeta
rinvgamma = function(n,delta,zeta){
  shape = delta
  rate = zeta
  1/rgamma(n,shape,rate)
}


##
## gibbs example with three random variables
## the model for the data is y_i|mu~N(mu,1)
## the prior for mu|a,b is mu~N(a,b)
## a and b are given a prior 
## and assumed independent in the prior
## the prior for a is a~N(0,1)
## the prior for b is b~InverseGamma(10,1)
## The full conditional for mu is N((s_n+a/b)/(n+1/b),1/(n+1/b))
## The full conditional for a is N((mu/b+0)/(1/b+1),1/(1/b+1))
## The full conditional for b is InverseGamma(0.5+10,0.5*(mu-a)^2+1)

#generating artificial data
mu = 10
n = 100
y = rnorm(n,mu,1)
s_n = sum(y)

#Initializing Sampler
N_samps = 10000
mu_curr = mean(y) #just somewhere to start
a_curr = 0 #just somewhere to start
b_curr = NA #this will be updated first

#making containers for output
mu_out = a_out = b_out = rep(NA,N_samps)

#Looping for the sampler
for(i in 1:N_samps){
  #updating
  b_curr = rinvgamma(1,0.5+10,0.5*(mu_curr-a_curr)^2+1)
  a_curr = rnorm(1,(mu_curr/b_curr+0)/(1/b_curr+1),sqrt(1/(1/b_curr+1)))
  mu_curr = rnorm(1,(s_n+a_curr/b_curr)/(n+1/b_curr),sqrt(1/(n+1/b_curr)))
  #storing
  mu_out[i] = mu_curr
  a_out[i] = a_curr
  b_out[i] = b_curr
}

#looking at the output
plot(mu_out,pch='.')
acf(mu_out)
plot(a_out,pch='.')
acf(a_out)
plot(b_out,pch='.')
acf(b_out)
#everything looks fine

#Drawing inference
#Density plots
plot(density(mu_out))
plot(density(a_out))
plot(density(b_out,from=0))
#posterior means
mean(mu_out)
mean(a_out)
mean(b_out)
#intervals
quantile(mu_out,c(0.025,0.975))
quantile(a_out,c(0.025,0.975))
quantile(b_out,c(0.025,0.975))
#correlation of parameters
cor(mu_out,a_out)
cor(mu_out,b_out)
cor(a_out,b_out)
#In the posterior, the 3 parameters are not independent. 

#predictions
y_pred = rnorm(N_samps,mu_out,1)
#comparison
plot(density(y))
lines(density(y_pred),col="blue",lty=2)
legend("topright",legend=c("KDE-Data","KDE-Predictions"),col=c("black","blue"),lty=c(1,2))
#predictions look like they match the data well
#the model seems sufficient for the data
#of course, the data was generted by the correct sampling distribution
#so it kind of has to be sufficient by design


