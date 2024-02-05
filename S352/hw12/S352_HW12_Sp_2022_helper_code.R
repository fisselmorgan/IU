##########
# k-fold split function
SPLIT_Kfold = function(n,K){
  ind = c(1:n)
  out = list()
  for(i in 1:(K-1)){
    size = length(ind)*1/(K-i+1)
    split = sort(sample(ind,size))
    ind = ind[ !( ind %in% split ) ]
    out[[i]] = split
  }
  out[[K]] = ind
  return(out)
}


##########
# Q1

# data loading
library(boot); data(poisons); y = poisons$time

# example theta_hat calculation
theta_hat_fun = function(y,alpha){
  theta_hat = alpha/mean(y)
  return(theta_hat)
}

# example loss calculation
loss_fun = function(theta_hat,y,alpha){
  loss = -mean(dgamma(y,shape=alpha,rate=theta_hat,log=TRUE))
  return(loss)
}


##########
# Q2

# data loading
library(boot); data(poisons); y = poisons$time

# example theta_hat calculation
theta_hat_fun = function(y,alpha){
  theta_hat = mean(y^alpha)^(1/alpha)
  return(theta_hat)
}

# example loss calculation
loss_fun = function(theta_hat,y,alpha){
  loss = -mean(dweibull(y,shape=alpha,scale=theta_hat,log=TRUE))
  return(loss)
}


##########
# Q3

# data loading
library(boot); data(discoveries); y = discoveries

# example theta_hat calculation
theta_hat_fun = function(y,alpha){
  theta_hat = mean(y)/(alpha+mean(y))
  return(theta_hat)
}

# example loss calculation
loss_fun = function(theta_hat,y,alpha){
  loss = -mean(dnbinom(y,size=alpha,prob=1-theta_hat,log=TRUE))
  return(loss)
}


##########
# Q4

# data loading
library(boot); data(acme); y=acme$acme

# density function
# f(x) = gamma(2*alpha)/gamma(alpha)^2*1/sigma*exp(alpha*(x-mu)/sigma)/(1+exp((x-mu)/sigma))^(2*alpha)
dlogisIII = function(x,mu,sigma,alpha,log=FALSE){
  z = 1/(1+exp(-(x-mu)/sigma))
  out = dbeta(z,alpha,alpha,log=TRUE)+log(z)+log(1-z)-log(sigma)
  if(log==TRUE){return(out)}else{return(exp(out))}
}

# mle function
mle_logisIII_fixed_shape = function(y,alpha){
  f = function(theta){
    mu=theta[1]; sigma = exp(theta[2]);
    return(sum(dlogisIII(y,mu,sigma,alpha,log=TRUE)))
  }
  opt = optim(c(0,0),f,control=list(fnscale=-1,reltol=1e-12))
  return(c(mu=opt$par[1],sigma=exp(opt$par[2])))
}

# example (mu_hat, sigma_hat) calculation
mu_sigma_hat_fun = function(y,alpha){
  estimate = mle_logisIII_fixed_shape(y,alpha)
  return(estimate)
}

# example loss calculation
loss_fun = function(mu_sigma_hat,y,alpha){
  loss = -mean(dlogisIII(y,mu=mu_sigma_hat[1],sigma=mu_sigma_hat[2],alpha=alpha,log=TRUE))
  return(loss)
}

##########
# Q5

# data loading
library(boot); data(amis); y=amis$speed

# density function
# f(x) = 1/(2*sigma*K_1(alpha))*exp(-alpha*sqrt(1+(x-mu)^2/sigma^2))
dhyperbolic = function(x,mu,sigma,alpha,log=FALSE){
  out = -alpha*sqrt(1+(x-mu)^2/sigma^2)-log(2*sigma)-alpha-log(besselK(alpha,1,TRUE))
  if(log==TRUE){return(out)}else{return(exp(out))}
}


# mle function
mle_hyperbolic_fixed_shape = function(y,alpha){
  f = function(theta){
    mu=theta[1]; sigma = exp(theta[2]);
    return(sum(dhyperbolic(y,mu,sigma,alpha,log=TRUE)))
  }
  opt = optim(c(0,0),f,control=list(fnscale=-1,reltol=1e-12))
  return(c(mu=opt$par[1],sigma=exp(opt$par[2])))
}

# example (mu_hat, sigma_hat) calculation
mu_sigma_hat_fun = function(y,alpha){
  estimate = mle_hyperbolic_fixed_shape(y,alpha)
  return(estimate)
}

# example loss calculation
loss_fun = function(mu_sigma_hat,y,alpha){
  loss = -mean(dhyperbolic(y,mu=mu_sigma_hat[1],sigma=mu_sigma_hat[2],alpha=alpha,log=TRUE))
  return(loss)
}


##########
# Q6

# data loading
library(boot); data(fir); y = fir$count

# example theta_hat calculation
theta_hat_fun = function(y,alpha){
  theta_hat = (alpha+sum(y))/(alpha+length(y))
  return(theta_hat)
}

# example loss calculation
loss_fun = function(theta_hat,y,alpha){
  loss = -mean(dpois(y,lambda=theta_hat,log=TRUE))
  return(loss)
}


##########
# Q7

# data loading
library(boot); data(nodal); y = nodal$stage

# example theta_hat calculation
theta_hat_fun = function(y,alpha){
  theta_hat = (alpha+sum(y))/(2*alpha+length(y))
  return(theta_hat)
}

# example loss calculation
loss_fun = function(theta_hat,y,alpha){
  loss = -mean(dbinom(y,1,prob=theta_hat,log=TRUE))
  return(loss)
}


##########
# Q8

# data loading
library(boot); data(acme); y=acme$acme

# example mu_hat calculation
mu_hat_fun = function(y,lambda){
  mu_hat = mean(y)/(1+lambda)
  return(mu_hat)
}

# example loss calculation
loss_fun = function(mu_hat,y,lambda){
  loss = mean((y-mu_hat)^2)
  return(loss)
}


##########
# Q9

# data loading
library(boot); data(amis); y=amis$speed

# example mu_hat calculation
mu_hat_fun = function(y,lambda){
  y_bar = mean(y)
  if(y_bar > lambda){
    mu_hat = y_bar - lambda
  }else if(y_bar < -lambda){
    mu_hat = y_bar + lambda
  }else{
    mu_hat = 0
  }
  return(mu_hat)
}

# example loss calculation
loss_fun = function(mu_hat,y,lambda){
  loss = mean((y-mu_hat)^2)
  return(loss)
}


##########
# Q10

# data loading
library(palmerpenguins); data("penguins");
y = penguins$flipper_length_mm; x = penguins$body_mass_g;
ind = !(is.na(y) | is.na(x)); y = y[ind]; x = x[ind]


# example mu_hat calculation
alpha_beta_hat_fun = function(y,x,lambda){
  mean_x = mean(x)
  mean_y = mean(y)
  cov_xy_hat = mean((y-mean_y)*(x-mean_x))
  var_x_hat = mean((x-mean_x)^2)
  beta_0 = cov_xy_hat/var_x_hat
  if(cov_xy_hat > lambda){
    beta_hat = beta_0 - lambda
  }else if(cov_xy_hat < -lambda){
    beta_hat = beta_0 + lambda
  }else{
    beta_hat = 0
  }
  alpha_hat = mean_y - beta_hat*mean(x)
  return(c(alpha=alpha_hat,beta=beta_hat))
}

# example loss calculation
loss_fun = function(alpha_beta_hat,y,x,lambda){
  loss = mean((y-(alpha_beta_hat[1]+x*alpha_beta_hat[2]))^2)
  return(loss)
}


##########
# Example 1 (from class)
# Estimation of Gamma distribution shape parameter (alpha) using 5-fold CV
# we will look at integer alpha from 1 to 200
# theta is rate and determined by MLE for given shape alpha
# prediction loss is average negative log density of test data using shape alpha and rate theta_hat_train

# split fun
SPLIT_Kfold = function(n,K){
  ind = c(1:n)
  out = list()
  for(i in 1:(K-1)){
    size = length(ind)*1/(K-i+1)
    split = sort(sample(ind,size))
    ind = ind[ !( ind %in% split ) ]
    out[[i]] = split
  }
  out[[K]] = ind
  return(out)
}

# fit fun
FIT = function(y,train_ind,alpha){
  # subset data
  y_train = y[train_ind]
  # compute estimate
  theta_hat_train = alpha/mean(y_train)
  # return estimate
  return(theta_hat_train)
}

# cvm fun
CVM = function(fit,y,train_ind,alpha){
  # fit is output from FIT and so is theta_hat_train
  theta_hat_train = fit
  # subset data
  y_test = y[-train_ind]
  # compute cvm
  cvm = -mean(dgamma(y_test,shape=alpha,rate=theta_hat_train,log=TRUE))
  # return loss
  return(cvm)
}

# loading some data for this analysis
data("faithful")
y = faithful$eruptions[faithful$waiting>72]

#alpha values
alpha = c(1:200)

## analysis approach 1, just code

# getting splits
n = length(y)
K = 5
splits = SPLIT_Kfold(n,K)

# container for average cvm over splits for each alpha[i]
avg_cvm = rep(NA,length(alpha))

#looping over alpha values
for(i in 1:length(alpha)){
  # local container for cvm over splits for a specific alpha[i]
  cvm_loc = rep(NA,K)
  #looping over splits
  for(j in 1:K){
    # get training indices
    # split is test indices
    # complement of split is training indices
    test_ind = splits[[j]]
    train_ind = c(1:n)[-test_ind]
    # local fit
    fit_loc = FIT(y,train_ind,alpha[i])
    # local cvm for jth split  
    cvm_loc[j] = CVM(fit_loc,y,train_ind,alpha[i])
  }
  #getting avg cvm for the specific alpha[i]
  avg_cvm[i] = mean(cvm_loc)
}

#looking at output 
plot(avg_cvm~alpha,type="l")
alpha[which.min(avg_cvm)]


## analysis approach 2, using a wrapper
CV_FUN = function(y,splits,alpha){
  # y is a data vector
  # splits is a list of vectors of indices
  n = length(y)
  K = length(splits)
  
  # container for cvm over splits
  cvm = rep(NA,K)
  #looping over splits
  for(j in 1:K){
    # get training indices
    # split is test indices
    # complement of split is training indices
    test_ind = splits[[j]]
    train_ind = c(1:n)[-test_ind]
    # local fit
    fit = FIT(y,train_ind,alpha)
    # local cvm for jth split  
    cvm[j] = CVM(fit,y,train_ind,alpha)
  }
  #getting avg cvm
  avg_cvm = mean(cvm)
  # returning average cvm
  return(avg_cvm)
}

# getting splits
n = length(y)
K = 5
splits = SPLIT_Kfold(n,K)

# container for average cvm over splits for each alpha[i]
avg_cvm = rep(NA,length(alpha))

#looping over alpha values
for(i in 1:length(alpha)){
  avg_cvm[i] = CV_FUN(y,splits,alpha[i])
}

#looking at output 
plot(avg_cvm~alpha,type="l")
alpha[which.min(avg_cvm)]


##########
# Example 2 (referenced in class but code not provided)
# Estimation of penalized least squares tuning parameter (lambda) using 5-fold CV
# we will look at 500 lambda values from 0.002 to 1
# penalized estimation by minimizing mean((y-theta)^2)+lambda*theta^2
# prediction loss is mean((y-theta_hat_train)^2)

# split fun
SPLIT_Kfold = function(n,K){
  ind = c(1:n)
  out = list()
  for(i in 1:(K-1)){
    size = length(ind)*1/(K-i+1)
    split = sort(sample(ind,size))
    ind = ind[ !( ind %in% split ) ]
    out[[i]] = split
  }
  out[[K]] = ind
  return(out)
}

# fit fun
FIT = function(y,train_ind,lambda){
  # subset data
  y_train = y[train_ind]
  # compute estimate
  theta_hat_train = mean(y_train)/(1+lambda)
  # return estimate
  return(theta_hat_train)
}

# cvm fun
CVM = function(fit,y,train_ind,lambda){
  # fit is output from FIT and so is theta_hat_train
  theta_hat_train = fit
  # subset data
  y_test = y[-train_ind]
  # compute cvm
  cvm = mean((y_test-theta_hat_train)^2)
  # return loss
  return(cvm)
}

# loading some data for this analysis
data("faithful")
y = faithful$eruptions[faithful$waiting>72]

#alpha values
lambda = seq(0.002,1,length.out = 300)

## analysis approach 1, just code

# getting splits
n = length(y)
K = 5
splits = SPLIT_Kfold(n,K)

# container for average cvm over splits for each lambda[i]
avg_cvm = rep(NA,length(lambda))

#looping over lambda values
for(i in 1:length(lambda)){
  # local container for cvm over splits for a specific lambda[i]
  cvm_loc = rep(NA,K)
  #looping over splits
  for(j in 1:K){
    # get training indices
    # split is test indices
    # complement of split is training indices
    test_ind = splits[[j]]
    train_ind = c(1:n)[-test_ind]
    # local fit
    fit_loc = FIT(y,train_ind,lambda[i])
    # local cvm for jth split  
    cvm_loc[j] = CVM(fit_loc,y,train_ind,lambda[i])
  }
  #getting avg cvm for the specific lambda[i]
  avg_cvm[i] = mean(cvm_loc)
}

#looking at output 
plot(avg_cvm~lambda,type="l")
lambda[which.min(avg_cvm)]


## analysis approach 2, using a wrapper
CV_FUN = function(y,splits,lambda){
  # y is a data vector
  # splits is a list of vectors of indices
  n = length(y)
  K = length(splits)
  
  # container for cvm over splits
  cvm = rep(NA,K)
  #looping over splits
  for(j in 1:K){
    # get training indices
    # split is test indices
    # complement of split is training indices
    test_ind = splits[[j]]
    train_ind = c(1:n)[-test_ind]
    # local fit
    fit = FIT(y,train_ind,lambda)
    # local cvm for jth split  
    cvm[j] = CVM(fit,y,train_ind,lambda)
  }
  #getting avg cvm
  avg_cvm = mean(cvm)
  # returning average cvm
  return(avg_cvm)
}

# getting splits
n = length(y)
K = 5
splits = SPLIT_Kfold(n,K)

# container for average cvm over splits for each lambda[i]
avg_cvm = rep(NA,length(lambda))

#looping over alpha values
for(i in 1:length(lambda)){
  avg_cvm[i] = CV_FUN(y,splits,lambda[i])
}

#looking at output 
plot(avg_cvm~lambda,type="l")
lambda[which.min(avg_cvm)]

