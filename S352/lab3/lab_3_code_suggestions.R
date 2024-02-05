# lab task 2
# we need to write a density function for the hyperbolic loss
dhyperbolic = function(y,mu,delta,alpha,log=FALSE){
  # log_dens = -loss - log(normalizing constant)
  log_NC_hyperbolic = function(delta,alpha){
    if(log(alpha)< -20){
      -log(alpha)+log(2)+log(delta)
    }else{
      log(besselK(alpha,1,TRUE)) - alpha + log(2)+log(delta)
    }
  }
  
  log_density = -alpha*sqrt(1+(y-mu)^2/delta^2) - log_NC_hyperbolic(delta,alpha)
  
  if(log==TRUE){
    return(log_density)
  }else{
    return(exp(log_density))
  }
  
}

# task 3
# thinking an MLE function
mle_hyperbolic = function(y){
  # need a log_likelihood function that takes in par
  # need to use optim on this function
  # return the par value from optim
  
  log_likelihood_fn = function(par){
    mu = par[1]
    delta = par[2]
    alpha = par[3]
    
    return(sum(dhyperbolic(y,mu,delta,alpha,log=TRUE)))
  }
  
  opt = optim(c(0,1,1),log_likelihood_fn,control = list(fnscale=-1))
  
  return(list(par = opt$par, loglik = opt$value))
}

# different version of this function
mle_hyperbolic_v2 = function(y){
  # need a log_likelihood function that takes in par
  # need to use optim on this function
  # return the par value from optim
  # use transformations to make optim's life easy
  
  log_likelihood_fn_trans = function(par){
    mu = par[1]
    delta = exp(par[2]) #has to be positive
    alpha = exp(par[3]) #has to be positive
    
    return(sum(dhyperbolic(y,mu,delta,alpha,log=TRUE)))
  }
  
  opt = optim(c(0,0,0),log_likelihood_fn_trans,control = list(fnscale=-1))
  
  par = opt$par
  par[2] = exp(par[2])
  par[3] = exp(par[3])
  names(par) = c("mu","delta","alpha")
  
  return(list(par = par, loglik = opt$value))
}


# task 1
# for data vector y
plot(density(y))
x_seq = seq(min(y),max(y),length.out=1000)
dens_norm = dnorm(x_seq,mean=normal_mle_mu,sd=normal_mle_sigma)
dens_laplace = dlaplace(x_seq,location=laplace_mle_mu,scale=laplace_mle_sigma)
#same for huber
lines(dens_norm~x_seq,col="blue",lty=2)
#same for the others

#add a legend
