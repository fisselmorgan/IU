library(boot) #used inside function

est_center_hyperbolic_ee = function(y,delta=IQR(y),conf=0.95,R=10000,
                                    tol=.Machine$double.eps^.5){
  #define the estimating equation function
  mean_psi = function(theta,y,delta=IQR(y)){
    -mean((y-theta)/sqrt(delta^2+(y-theta)^2))
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

#test it!
y = rgamma(100,shape=4,rate=1) 
#theoretically, mean should be like 4, median like 3.67
#your estimates will differ
c(mean(y),median(y))
delta = c(.1,1,5,10,20)
est_center_hyperbolic_ee(y,delta)
