library(boot)
data(melanoma)
y = log(melanoma$thickness)

# Q1 a)
# Idea 1
##AJW## need parentheses in the denominators
## (2*delta)
## this happens later too, just make sure to fix them all
mean_rho = function(theta,y,delta=IQR(y)){
  mean(log(exp((y-theta)/(2*delta)) + exp(-1*(y-theta)/(2*delta))))
}

#estimating function
mean_psi = function(theta,y,delta=IQR(y)){
  y_trans = (y-theta)/(2*delta)
  exp_bit = exp(y_trans)
  exp_minus_bit = exp(-y_trans)
  -mean((1/(2*delta))*((exp_bit - exp_minus_bit)/(exp_bit + exp_minus_bit)))
  
}

#vectorized version 
V_mean_rho = Vectorize(mean_rho,vectorize.args = "theta")
V_mean_psi = Vectorize(mean_psi,vectorize.args = "theta")

theta = seq(min(y),max(y),length.out=1000)
loss = V_mean_rho(theta,y=y)
plot(loss~theta,main="Logistic Loss",ylab="loss",xlab=expression(theta),type="l")
est_f = V_mean_psi(theta,y=y)
plot(est_f~theta,type="l",main="Logistic Estimating Function",xlab=expression(theta)
     ,ylab="estimating function")

# b)
optimize(mean_rho,interval=range(y),y=y)
uniroot(mean_psi,range(y),y=y)

# c) 
rho_opt = function(delta,y){
  optimize(mean_rho,range(y),y=y,delta=delta)$minimum
}

psi_root = function(delta,y){
  uniroot(mean_psi,range(y),y=y,delta=delta)$root
}

# Vectorize 
V_rho_opt = Vectorize(rho_opt,vectorize.args = "delta")
V_psi_root = Vectorize(psi_root,vectorize.args = "delta")

delta = seq(0.005,5,length.out=1000)

V_rho_opt_out = V_rho_opt(delta=delta,y=y)
plot(V_rho_opt_out~delta,type="l",main="Logistic Loss Estimator",xlab=expression(delta)
     ,ylab="Risk Minimizer")
V_psi_root_out = V_psi_root(delta=delta,y=y)
plot(V_psi_root_out~delta,type="l",main="Logistic Loss Estimator",xlab=expression(delta)
     ,ylab="Estimating Equation Solution")


# d)
est_rho = function(y,delta=IQR(y),conf=0.95,R=10000,
                                    tol=.Machine$double.eps^.5){
  #define the loss function
  mean_rho = function(theta,y,delta=IQR(y)){
    mean(log(exp((y-theta)/(2*delta)) + exp(-1*(y-theta)/(2*delta))))
  }
  #define the function that returns the estimate
  est_fun = function(y,delta=IQR(y)){
    optimize(f=mean_rho,interval=range(y),y=y,delta=delta,tol=tol)$minimum
  }
  #Vectorize it over delta
  V_est_fun = Vectorize(est_fun,vectorize.args = "delta")
  #define a bootable function that that returns the vector estimate
  est_fun_bootable = function(y,ind=c(1:length(y)),delta=IQR(y)){
    y_rep = y[ind]
    V_est_fun(y=y_rep,delta=delta)
  }
  #do the bootstrapping
  boot_out = boot(y,est_fun_bootable,delta=delta,R=R)
  #loop to get the cis and point estimates output
  lower = upper = rep(NA,length(delta))
  for(i in 1:length(delta)){
    loc_ci = boot.ci(boot_out,conf=conf,type="bca",index=i)
    lower[i] = loc_ci$bca[4]
    upper[i] = loc_ci$bca[5]
  }
  
  #return output
  return(data.frame(delta=delta,est=boot_out$t0,lower=lower,upper=upper))
}


est_psi = function(y,delta=IQR(y),conf=0.95,R=10000,
                                    tol=.Machine$double.eps^.5){
  #define the estimating equation function
  mean_psi = function(theta,y,delta=IQR(y)){
    -mean((-1/(2*delta))*(exp((y-theta)/(2*delta)) - exp(-1*((y-theta)/(2*delta)))) /
            exp((y-theta)/(2*delta)) + exp(-1*((y-theta)/(2*delta))))
  }
  #define the function that returns the estimate
  est_fun = function(y,delta=IQR(y)){
    uniroot(f=mean_psi,interval=range(y),y=y,delta=delta,tol=tol)$root
  }
  #Vectorize it over delta
  V_est_fun = Vectorize(est_fun,vectorize.args = "delta")
  #define a bootable function that that returns the vector estimate
  est_fun_bootable = function(y,ind=c(1:length(y)),delta=IQR(y)){
    y_rep = y[ind]
    V_est_fun(y=y_rep,delta=delta)
  }
  #do the bootstrapping
  boot_out = boot(y,est_fun_bootable,delta=delta,R=R)
  #loop to get the cis and point estimates output
  lower = upper = rep(NA,length(delta))
  for(i in 1:length(delta)){
    loc_ci = boot.ci(boot_out,conf=conf,type="bca",index=i)
    lower[i] = loc_ci$bca[4]
    upper[i] = loc_ci$bca[5]
  }
  
  #return output
  return(data.frame(delta=delta,est=boot_out$t0,lower=lower,upper=upper))
}

est_rho(y=y,delta)
est_psi(y=y,delta)


# e)
est_rhoD = function(y,delta=delta,conf=0.98,R=10000,
                   tol=.Machine$double.eps^.5){
  #define the loss function
  mean_rho = function(theta,y,delta=delta){
    mean(log(exp((y-theta)/(2*delta)) + exp(-1*(y-theta)/(2*delta))))
  }
  #define the function that returns the estimate
  est_fun = function(y,delta=delta){
    optimize(f=mean_rho,interval=range(y),y=y,delta=delta,tol=tol)$minimum
  }
  #Vectorize it over delta
  V_est_fun = Vectorize(est_fun,vectorize.args = "delta")
  #define a bootable function that that returns the vector estimate
  est_fun_bootable = function(y,ind=c(1:length(y)),delta=delta){
    y_rep = y[ind]
    V_est_fun(y=y_rep,delta=delta)
  }
  #do the bootstrapping
  boot_out = boot(y,est_fun_bootable,delta=delta,R=R)
  #loop to get the cis and point estimates output
  lower = upper = rep(NA,length(delta))
  for(i in 1:length(delta)){
    loc_ci = boot.ci(boot_out,conf=conf,type="bca",index=i)
    lower[i] = loc_ci$bca[4]
    upper[i] = loc_ci$bca[5]
  }
  
  #return output
  return(data.frame(delta=delta,est=boot_out$t0,lower=lower,upper=upper))
}


est_psiD = function(y,delta=delta,conf=0.98,R=10000,
                   tol=.Machine$double.eps^.5){
  #define the estimating equation function
  mean_psi = function(theta,y,delta=delta){
    -mean((-1/(2*delta))*(exp((y-theta)/(2*delta)) - exp(-1*((y-theta)/(2*delta)))) /
            exp((y-theta)/(2*delta)) + exp(-1*((y-theta)/(2*delta))))
  }
  #define the function that returns the estimate
  est_fun = function(y,delta=delta){
    uniroot(f=mean_psi,interval=range(y),y=y,delta=delta,tol=tol)$root
  }
  #Vectorize it over delta
  V_est_fun = Vectorize(est_fun,vectorize.args = "delta")
  #define a bootable function that that returns the vector estimate
  est_fun_bootable = function(y,ind=c(1:length(y)),delta=delta){
    y_rep = y[ind]
    V_est_fun(y=y_rep,delta=delta)
  }
  #do the bootstrapping
  boot_out = boot(y,est_fun_bootable,delta=delta,R=R)
  #loop to get the cis and point estimates output
  lower = upper = rep(NA,length(delta))
  for(i in 1:length(delta)){
    loc_ci = boot.ci(boot_out,conf=conf,type="bca",index=i)
    lower[i] = loc_ci$bca[4]
    upper[i] = loc_ci$bca[5]
  }
  
  #return output
  return(data.frame(delta=delta,est=boot_out$t0,lower=lower,upper=upper))
}

est_rhoD(y=y,delta=c(0,1,2,4))
est_psiD(y=y,delta=c(0,1,2,4))
# I am not sure why this is creating warnings?

