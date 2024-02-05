#1a)
# data - the package 'boot' needs to be installed
library(boot)
data(melanoma); y = melanoma$thickness
#density - dgamma - built in
# mle
mle_gamma = function(y,vcov=TRUE){
  #takes advantage of scoping
  loglik_fun = function(theta){#scoping, looks for y one environment up
    alpha = theta[1]
    beta = theta[2]
    sum(dgamma(y,shape=alpha,rate=beta,log=TRUE))
  }
  loglik_fun_trans = function(theta){#scoping, looks for y one environment up
    alpha = exp(theta[1])
    beta = exp(theta[2])
    sum(dgamma(y,shape=alpha,rate=beta,log=TRUE))
  }
  #using optim to get MLE
  #we use the _trans function and then undo the transformation for the estimate without the transformation
  fit_trans = optim(c(0,0),loglik_fun_trans,control=list(fnscale=-1,maxit=10000)) #scoping, looks for y one environment up
  fit = fit_trans
  fit$par[1] = exp(fit$par[1])
  fit$par[2] = exp(fit$par[2])
  dim = 2
  AIC = -2*fit$value + 2*dim
  names(fit$par) = c("alpha","beta") #NAMES ARE GOOD
  if(!vcov){
    return(list(theta=fit$par,loglik=fit$value,dim=dim,AIC=AIC))
  }else{
    #using optimHess to get the Hessian
    #we use the regular log-likelihood function
    fit_hess = optimHess(fit$par,loglik_fun)#scoping, looks for y one environment up
    #we convert the Hessian into a variance-covariance matrix
    #inversion is achieved using solve
    fit_vcov = solve(-fit_hess)
    rownames(fit_vcov) = colnames(fit_vcov) = names(fit$par)#NAMES ARE COPIED HERE
    return(list(theta=fit$par,loglik=fit$value,dim=dim,AIC=AIC,vcov=fit_vcov))
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
mle_logisIII = function(y,vcov=TRUE){
  #takes advantage of scoping
  loglik_fun = function(theta){#scoping, looks for y one environment up
    mu = theta[1]
    delta = theta[2]
    alpha = theta[3]
    sum(dlogisIII(y,location=mu,scale=delta,shape=alpha,log=TRUE))
  }
  loglik_fun_trans = function(theta){#scoping, looks for y one environment up
    mu = theta[1]
    delta = exp(theta[2])
    alpha = exp(theta[3])
    sum(dlogisIII(y,location=mu,scale=delta,shape=alpha,log=TRUE))
  }
  #using optim to get MLE
  #we use the _trans function and then undo the transformation for the estimate without the transformation
  fit_trans = optim(c(0,0,0),loglik_fun_trans,control=list(fnscale=-1,maxit=10000)) #scoping, looks for y one environment up
  fit = fit_trans
  fit$par[1] = fit$par[1]
  fit$par[2] = exp(fit$par[2])
  fit$par[3] = exp(fit$par[3])
  dim = 3
  AIC = -2*fit$value + 2*dim
  names(fit$par) = c("mu","delta","alpha") #NAMES ARE GOOD
  if(!vcov){
    return(list(theta=fit$par,loglik=fit$value,dim=dim,AIC=AIC))
  }else{
    #using optimHess to get the Hessian
    #we use the regular log-likelihood function
    fit_hess = optimHess(fit$par,loglik_fun)#scoping, looks for y one environment up
    #we convert the Hessian into a variance-covariance matrix
    #inversion is achieved using solve
    fit_vcov = solve(-fit_hess)
    rownames(fit_vcov) = colnames(fit_vcov) = names(fit$par)#NAMES ARE COPIED HERE
    return(list(theta=fit$par,loglik=fit$value,dim=dim,AIC=AIC,vcov=fit_vcov))
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
mle_gengamma = function(y,vcov=TRUE){
  #takes advantage of scoping
  loglik_fun = function(theta){#scoping, looks for y one environment up
    d = theta[1]
    k = theta[2]
    s = theta[3]
    sum(dgengamma(y,d,k,s,log=TRUE))
  }
  loglik_fun_trans = function(theta){#scoping, looks for y one environment up
    d = exp(theta[1])
    k = exp(theta[2])
    s = exp(theta[3])
    sum(dgengamma(y,d,k,s,log=TRUE))
  }
  #using optim to get MLE
  #we use the _trans function and then undo the transformation for the estimate without the transformation
  fit_trans = optim(c(0,0,0),loglik_fun_trans,control=list(fnscale=-1,maxit=10000)) #scoping, looks for y one environment up
  fit = fit_trans
  fit$par[1] = exp(fit$par[1])
  fit$par[2] = exp(fit$par[2])
  fit$par[3] = exp(fit$par[3])
  dim = 3
  AIC = -2*fit$value + 2*dim
  names(fit$par) = c("d","k","s") #NAMES ARE GOOD
  if(!vcov){
    return(list(theta=fit$par,loglik=fit$value,dim=dim,AIC=AIC))
  }else{
    #using optimHess to get the Hessian
    #we use the regular log-likelihood function
    fit_hess = optimHess(fit$par,loglik_fun)#scoping, looks for y one environment up
    #we convert the Hessian into a variance-covariance matrix
    #inversion is achieved using solve
    fit_vcov = solve(-fit_hess)
    rownames(fit_vcov) = colnames(fit_vcov) = names(fit$par)#NAMES ARE COPIED HERE
    return(list(theta=fit$par,loglik=fit$value,dim=dim,AIC=AIC,vcov=fit_vcov))
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
mle_hyperbolic = function(y,vcov=TRUE){
  #takes advantage of scoping
  loglik_fun = function(theta){#scoping, looks for y one environment up
    mu = theta[1]
    delta = theta[2]
    alpha = theta[3]
    sum(dhyperbolic(y,mu,delta,alpha,log=TRUE))
  }
  loglik_fun_trans = function(theta){#scoping, looks for y one environment up
    mu = theta[1]
    delta = exp(theta[2])
    alpha = exp(theta[3])
    sum(dhyperbolic(y,mu,delta,alpha,log=TRUE))
  }
  #using optim to get MLE
  #we use the _trans function and then undo the transformation for the estimate without the transformation
  fit_trans = optim(c(0,0,0),loglik_fun_trans,control=list(fnscale=-1,maxit=10000)) #scoping, looks for y one environment up
  fit = fit_trans
  fit$par[1] = fit$par[1]
  fit$par[2] = exp(fit$par[2])
  fit$par[3] = exp(fit$par[3])
  dim = 3
  AIC = -2*fit$value + 2*dim
  names(fit$par) = c("mu","delta","alpha") #NAMES ARE GOOD
  if(!vcov){
    return(list(theta=fit$par,loglik=fit$value,dim=dim,AIC=AIC))
  }else{
    #using optimHess to get the Hessian
    #we use the regular log-likelihood function
    fit_hess = optimHess(fit$par,loglik_fun)#scoping, looks for y one environment up
    #we convert the Hessian into a variance-covariance matrix
    #inversion is achieved using solve
    fit_vcov = solve(-fit_hess)
    rownames(fit_vcov) = colnames(fit_vcov) = names(fit$par)#NAMES ARE COPIED HERE
    return(list(theta=fit$par,loglik=fit$value,dim=dim,AIC=AIC,vcov=fit_vcov))
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
mle_linmod = function(x,y,vcov=TRUE){
  #takes advantage of scoping
  loglik_fun = function(theta){#scoping, looks for y one environment up
    alpha = theta[1]
    beta = theta[2]
    sigma = theta[3]
    sum(dlinmod(x,y,alpha,beta,sigma,log=TRUE))
  }
  loglik_fun_trans = function(theta){#scoping, looks for y one environment up
    alpha = theta[1]
    beta = theta[2]
    sigma = exp(theta[3])
    sum(dlinmod(x,y,alpha,beta,sigma,log=TRUE))
  }
  #using optim to get MLE
  #we use the _trans function and then undo the transformation for the estimate without the transformation
  #I had to change the starting point for the optimization for optim to work
  fit_trans = optim(c(mean(y),0,0),loglik_fun_trans,control=list(fnscale=-1,maxit=10000)) #scoping, looks for y one environment up
  fit = fit_trans
  fit$par[1] = fit$par[1]
  fit$par[2] = fit$par[2]
  fit$par[3] = exp(fit$par[3])
  dim = 3
  AIC = -2*fit$value + 2*dim
  names(fit$par) = c("alpha","beta","sigma") #NAMES ARE GOOD
  if(!vcov){
    return(list(theta=fit$par,loglik=fit$value,dim=dim,AIC=AIC))
  }else{
    #using optimHess to get the Hessian
    #we use the regular log-likelihood function
    fit_hess = optimHess(fit$par,loglik_fun)#scoping, looks for y one environment up
    #we convert the Hessian into a variance-covariance matrix
    #inversion is achieved using solve
    fit_vcov = solve(-fit_hess)
    rownames(fit_vcov) = colnames(fit_vcov) = names(fit$par)#NAMES ARE COPIED HERE
    return(list(theta=fit$par,loglik=fit$value,dim=dim,AIC=AIC,vcov=fit_vcov))
  }
}


