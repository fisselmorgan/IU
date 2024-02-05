dlogisIII=function(x,location=0,scale=1,shape=1,log=FALSE){
  x = (x-location)/scale
  log_y = ifelse(x<0,x-log(1+exp(x)),-log(1+exp(-x)))
  log_1my = ifelse(x<0,-log(1+exp(x)),-x-log(1+exp(-x)))
  out = -log(scale)-lbeta(shape,shape) + (shape)*(log_y+log_1my)
  if(log){return(out)}else{return(exp(out))}
}
plogisIII=function(q,location=0,scale=1,shape=1,lower.tail=TRUE,log.p=FALSE){
  q = (q-location)/scale
  Q = ifelse(q<0,exp(q)/(1+exp(q)),1/(1+exp(-q)))
  return(pbeta(Q,shape,shape,0,lower.tail,log.p))
}
qlogisIII=function(p,location=0,scale=1,shape=1,lower.tail=TRUE,log.p=FALSE){
  Q = qbeta(p,shape,shape,0,lower.tail,log.p)
  q = ifelse(Q<0.5,log(Q)-log(1-Q),-log(1/Q-1))
  return(q*scale+location)
}
rlogisIII=function(n,location=0,scale=1,shape=1){
  b = rbeta(n,shape,shape,0)
  x = ifelse(b<0.5,log(b)-log(1-b),-log(1/b-1))
  return(x*scale+location)
}



mle_logis = function(y){
  #function to optimize using optim
  f = function(theta){
    mu = theta[1]
    delta = exp(theta[2]) #note the transformation
    sum(dlogis(y,location=mu,scale=delta,log=TRUE))
  }
  #using optim - starting at a guess of mu=0 and log(delta)=0 -- par=c(0,0)
  opt_out = optim(par=c(0,0),f,control=list(fnscale=-1,maxit=1000,reltol=1e-8))
  par = opt_out$par
  par[2] = exp(par[2]) #transforming to delta
  names(par) = c("mu","delta") #NAMES ARE GOOD
  out = list(theta=par,loglik=opt_out$value)
  return(out)
}
