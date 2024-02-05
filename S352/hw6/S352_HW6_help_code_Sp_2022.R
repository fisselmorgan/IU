#1a)
# data - the package 'boot' needs to be installed
library(boot)
data(melanoma); y = melanoma$thickness
#density - dgamma - built in
# mle for fixed shape parameter
mle_gamma_fixed_shape = function(y,alpha_0,vcov=TRUE){
  #takes advantage of scoping
  loglik_fun = function(theta){#scoping, looks for y one environment up
    alpha = alpha_0
    beta = theta
    sum(dgamma(y,shape=alpha,rate=beta,log=TRUE))
  }
  loglik_fun_trans = function(theta){#scoping, looks for y one environment up
    alpha = alpha_0 
    beta = exp(theta)
    sum(dgamma(y,shape=alpha,rate=beta,log=TRUE))
  }
  #using optim to get MLE
  #we use the _trans function and then undo the transformation for the estimate without the transformation
  fit_trans = optim(c(0),method="Brent",lower=-20,upper=20,
                    loglik_fun_trans,control=list(fnscale=-1,maxit=10000)) #scoping, looks for y one environment up
  fit = fit_trans
  fit$par = exp(fit$par)
  d = 1
  AIC = -2*fit$value + 2*d
  names(fit$par) = c("beta") #NAMES ARE GOOD
  if(!vcov){
    return(list(theta=fit$par,alpha=alpha_0,loglik=fit$value,dim=d,AIC=AIC))
  }else{
    #using optimHess to get the Hessian
    #we use the regular log-likelihood function
    fit_hess = optimHess(fit$par,loglik_fun)#scoping, looks for y one environment up
    #we convert the Hessian into a variance-covariance matrix
    #inversion is achieved using solve
    fit_vcov = solve(-fit_hess)
    rownames(fit_vcov) = colnames(fit_vcov) = names(fit$par)#NAMES ARE COPIED HERE
    return(list(theta=fit$par,alpha=alpha_0,loglik=fit$value,dim=d,AIC=AIC,vcov=fit_vcov))
  }
}

#1b)
# data - the package 'boot' needs to be installed
library(boot); data(melanoma); y = log(melanoma$thickness)
#density - dlogisIII - provided
dlogisIII=function(x,location=0,scale=1,shape=1,log=FALSE){
  x = (x-location)/scale
  log_y = ifelse(x<0,x-log(1+exp(x)),-log(1+exp(-x)))
  log_1my = ifelse(x<0,-log(1+exp(x)),-x-log(1+exp(-x)))
  out = -log(scale)-lbeta(shape,shape) + (shape)*(log_y+log_1my)
  if(log){return(out)}else{return(exp(out))}
}
# mle
mle_logisIII_fix_shape = function(y,alpha_0,vcov=TRUE){
  #takes advantage of scoping
  loglik_fun = function(theta){#scoping, looks for y one environment up
    mu = theta[1]
    delta = theta[2]
    alpha = alpha_0
    sum(dlogisIII(y,location=mu,scale=delta,shape=alpha,log=TRUE))
  }
  loglik_fun_trans = function(theta){#scoping, looks for y one environment up
    mu = theta[1]
    delta = exp(theta[2])
    alpha = alpha_0
    sum(dlogisIII(y,location=mu,scale=delta,shape=alpha,log=TRUE))
  }
  #using optim to get MLE
  #we use the _trans function and then undo the transformation for the estimate without the transformation
  fit_trans = optim(c(0,0),loglik_fun_trans,control=list(fnscale=-1,maxit=10000)) #scoping, looks for y one environment up
  fit = fit_trans
  fit$par[1] = fit$par[1]
  fit$par[2] = exp(fit$par[2])
  d = 2
  AIC = -2*fit$value + 2*d
  names(fit$par) = c("mu","delta") #NAMES ARE GOOD
  if(!vcov){
    return(list(theta=fit$par,alpha=alpha_0,loglik=fit$value,dim=d,AIC=AIC))
  }else{
    #using optimHess to get the Hessian
    #we use the regular log-likelihood function
    fit_hess = optimHess(fit$par,loglik_fun)#scoping, looks for y one environment up
    #we convert the Hessian into a variance-covariance matrix
    #inversion is achieved using solve
    fit_vcov = solve(-fit_hess)
    rownames(fit_vcov) = colnames(fit_vcov) = names(fit$par)#NAMES ARE COPIED HERE
    return(list(theta=fit$par,loglik=fit$value,dim=d,AIC=AIC,vcov=fit_vcov))
  }
}

#1c)
# data - built in
y = faithful$eruptions[faithful$waiting>71]
#density - dgengamma - provided
dgengamma = function(y,d,k,s,log=FALSE){
  out = log(k) -lgamma(d/k) -d*log(s) +log(y)*(d-1) -(y/s)^k
  if(log){out}else{exp(out)}
}
# mle
mle_gengamma_fix_shape = function(y,alpha_0,vcov=TRUE){
  #takes advantage of scoping
  loglik_fun = function(theta){#scoping, looks for y one environment up
    k = theta[1]
    d = alpha_0*k
    s = theta[2]
    sum(dgengamma(y,d,k,s,log=TRUE))
  }
  loglik_fun_trans = function(theta){#scoping, looks for y one environment up
    k = exp(theta[1])
    d = alpha_0*k
    s = exp(theta[2])
    sum(dgengamma(y,d,k,s,log=TRUE))
  }
  #using optim to get MLE
  #we use the _trans function and then undo the transformation for the estimate without the transformation
  fit_trans = optim(c(0,0),loglik_fun_trans,control=list(fnscale=-1,maxit=10000)) #scoping, looks for y one environment up
  fit = fit_trans
  fit$par[1] = exp(fit$par[1])
  fit$par[2] = exp(fit$par[2])
  d = 2
  AIC = -2*fit$value + 2*d
  names(fit$par) = c("k","s") #NAMES ARE GOOD
  if(!vcov){
    return(list(theta=fit$par,alpha=alpha_0,loglik=fit$value,dim=d,AIC=AIC))
  }else{
    #using optimHess to get the Hessian
    #we use the regular log-likelihood function
    fit_hess = optimHess(fit$par,loglik_fun)#scoping, looks for y one environment up
    #we convert the Hessian into a variance-covariance matrix
    #inversion is achieved using solve
    fit_vcov = solve(-fit_hess)
    rownames(fit_vcov) = colnames(fit_vcov) = names(fit$par)#NAMES ARE COPIED HERE
    return(list(theta=fit$par,loglik=fit$value,dim=d,AIC=AIC,vcov=fit_vcov))
  }
}

#1d)
# data - the package 'boot' needs to be installed
library(boot); data("acme"); y = acme$acme
#density - dhyperbolic - provided
dhyperbolic = function(y,mu=0,delta=1,alpha=1,log=FALSE){
  if(log(alpha)< -20){
    log_NC = -log(alpha)+log(2)+log(delta)
  }else{
    log_NC = log(besselK(alpha,1,TRUE)) - alpha + log(2)+log(delta)
  }
  loss = alpha*sqrt(1+(y-mu)^2/delta^2)
  out = -loss -log_NC
  if(log==TRUE){out}else{exp(out)}
}
# mle
mle_hyperbolic_fix_mean = function(y,mu_0,vcov=TRUE){
  #takes advantage of scoping
  loglik_fun = function(theta){#scoping, looks for y one environment up
    mu = mu_0
    delta = theta[1]
    alpha = theta[2]
    sum(dhyperbolic(y,mu,delta,alpha,log=TRUE))
  }
  loglik_fun_trans = function(theta){#scoping, looks for y one environment up
    mu = mu_0
    delta = exp(theta[1])
    alpha = exp(theta[2])
    sum(dhyperbolic(y,mu,delta,alpha,log=TRUE))
  }
  #using optim to get MLE
  #we use the _trans function and then undo the transformation for the estimate without the transformation
  fit_trans = optim(c(0,0),loglik_fun_trans,control=list(fnscale=-1,maxit=10000)) #scoping, looks for y one environment up
  fit = fit_trans
  fit$par[1] = exp(fit$par[1])
  fit$par[2] = exp(fit$par[2])
  d = 2
  AIC = -2*fit$value + 2*d
  names(fit$par) = c("delta","alpha") #NAMES ARE GOOD
  if(!vcov){
    return(list(theta=fit$par,mu=mu_0,loglik=fit$value,dim=d,AIC=AIC))
  }else{
    #using optimHess to get the Hessian
    #we use the regular log-likelihood function
    fit_hess = optimHess(fit$par,loglik_fun)#scoping, looks for y one environment up
    #we convert the Hessian into a variance-covariance matrix
    #inversion is achieved using solve
    fit_vcov = solve(-fit_hess)
    rownames(fit_vcov) = colnames(fit_vcov) = names(fit$par)#NAMES ARE COPIED HERE
    return(list(theta=fit$par,mu=mu_0,loglik=fit$value,dim=d,AIC=AIC,vcov=fit_vcov))
  }
}

#1e)
# data - the package 'palmerpenguins' needs to be installed
library(palmerpenguins); y = penguins$flipper_length_mm; x = penguins$body_mass_g
ind = !(is.na(x)&is.na(y)); y=y[ind]; x=x[ind]
#density - dlinmod - provided
dlinmod = function(x,y,alpha,beta,sigma,log=FALSE){
  dnorm(y,alpha+beta*x,sigma,log)
}
# mle
mle_linmod_fixed_slope = function(x,y,beta_0,vcov=TRUE){
  #takes advantage of scoping
  loglik_fun = function(theta){#scoping, looks for y one environment up
    alpha = theta[1]
    beta = beta_0
    sigma = theta[2]
    sum(dlinmod(x,y,alpha,beta,sigma,log=TRUE))
  }
  loglik_fun_trans = function(theta){#scoping, looks for y one environment up
    alpha = theta[1]
    beta = beta_0
    sigma = exp(theta[2])
    sum(dlinmod(x,y,alpha,beta,sigma,log=TRUE))
  }
  #using optim to get MLE
  #we use the _trans function and then undo the transformation for the estimate without the transformation
  #I had to change the starting point for the optimization for optim to work
  fit_trans = optim(c(mean(y),0),loglik_fun_trans,control=list(fnscale=-1,maxit=10000)) #scoping, looks for y one environment up
  fit = fit_trans
  fit$par[1] = fit$par[1]
  fit$par[2] = exp(fit$par[2])
  d = 2
  AIC = -2*fit$value + 2*d
  names(fit$par) = c("alpha","sigma") #NAMES ARE GOOD
  if(!vcov){
    return(list(theta=fit$par,beta=beta_0,loglik=fit$value,dim=d,AIC=AIC))
  }else{
    #using optimHess to get the Hessian
    #we use the regular log-likelihood function
    fit_hess = optimHess(fit$par,loglik_fun)#scoping, looks for y one environment up
    #we convert the Hessian into a variance-covariance matrix
    #inversion is achieved using solve
    fit_vcov = solve(-fit_hess)
    rownames(fit_vcov) = colnames(fit_vcov) = names(fit$par)#NAMES ARE COPIED HERE
    return(list(theta=fit$par,beta=beta_0,loglik=fit$value,dim=d,AIC=AIC,vcov=fit_vcov))
  }
}

#2) example
CI_weibull_scale_fixed_shape = function(z,k=2,conf=0.95){#shape k is fixed, defaults to 2
  n = length(z) #getting sample size
  cutoff = qchisq(1-conf,1,lower.tail = FALSE) #or qchisq(conf,1,lower.tail = TRUE)
  lambda_hat = (mean(z^k))^(1/k) #the MLE under the alternative, does not change
  lrt_stat_minus_cutoff = function(lambda_0){
    if(lambda_0 <=0){ #checking boundaries, lambda must be positive
      return(Inf)
    }else{
      lrt_stat = 2*n*(k*log(lambda_0/lambda_hat)+lambda_hat^k/lambda_0^k-1)
      return(lrt_stat - cutoff) 
    }
  }
  interval = c(0,lambda_hat) #for the lower bound, using the constraint and the MLE
  lower = uniroot(lrt_stat_minus_cutoff,interval,extendInt = "downX",tol = 1e-10,maxiter=10000) #extendInt="downX" is actually doing nothing here becasue of the constraint
  interval = c(0,10)+lambda_hat #for the upper bound, MLE to MLE+10 (+10 was arbitrary and I could probably have been more clever in how I chose it)
  upper = uniroot(lrt_stat_minus_cutoff,interval,extendInt = "upX",tol = 1e-10,maxiter=10000) #extendint="upX" is extending the interval looking for an up crossing. This is in case the +10 was not enough.
  return(c(estimate=lambda_hat,lower=lower$root,upper=upper$root))
}

#a simulation to test the coverage - just for fun
N_sim = 1000 #number of simulations
out = rep(NA,N_sim) #container for output
lambda_true = 10 #true scale parameter
k = 2 #fixed shape
n = 100 #fixed sample size
conf = 0.95
for(i in 1:N_sim){ #for loop for simulation
  z = rweibull(n,shape=k,scale=lambda_true) #random sample
  ci = CI_weibull_scale_fixed_shape(z,k=k,conf=conf) #getting confidence interval for scale
  out[i] = (ci["lower"]<lambda_true && ci["upper"]>lambda_true) #TRUE/FALSE for whether interval contains the true scale
}
coverage_est = mean(out) #estimated probability that intervals (that are random because of sampling) contain the true scale parameter value
#making a 0.99 confidence interval for coverage using the CLT and the fact the N_sim is large
sd_coverage_est = sqrt(conf*(1-conf)/N_sim)
coverage_ci = coverage_est + c(-1,1)*qnorm(0.995)*sd_coverage_est
print(coverage_ci)
