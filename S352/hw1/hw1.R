library(boot)
data(faithful)
y = faithful$eruptions[faithful$waiting>71]

shape_estimator_fun_using_mean_and_log = function(x,ind){
  if(missing(ind)){ind = c(1:length(x))}
  
  x = x[ind]
  
  log_mean_x = log(mean(x))
  mean_log_x = mean(log(x))
  
  h = function(alpha){
    if(alpha<=0){return(NA)}
    return((digamma(alpha) - (log(alpha)) - (mean_log_x-log_mean_x)))
  }
  
  root_output = uniroot(f=h,interval=c(.01,100),extendInt = "yes") 
  return(root_output$root)
}

alpha_est_wrapped = shape_estimator_fun_using_mean_and_log(y)
boot_out1 = boot(y,shape_estimator_fun_using_mean_and_log,R = 10000)
boot_ci_out1 = boot.ci(boot_out1,conf = 0.95,type=c("basic","bca"))


shape_estimator_fun_using_mean_and_variance = function(x,ind){
  if(missing(ind)){ind = c(1:length(x))}
  
  x = x[ind]
  
  x_bar = mean(x)
  s_squared_x = mean((x-x_bar)^2)
  
  h = function(alpha){
    if(alpha<=0){return(NA)}
    return(alpha - x_bar^2/s_squared_x)
  }
  
  root_output = uniroot(f=h,interval=c(.01,100),extendInt = "yes") 
  return(root_output$root)
}

boot_out2 = boot(y, shape_estimator_fun_using_mean_and_variance, R=10000)
boot_ci_out2 = boot.ci(boot_out2, conf = 0.95, type=c("basic","bca"))

boot_ci_out1
boot_ci_out2

# e) I think in this case I prefer the shape est. w/ mean and log. 
# However there doesn't seem to be a whole lot of difference between the log and variance shape est.
# I prefer the mean/log because it has slightly smaller interval over both the basic and bca
# bca is also has a slightly smaller range of values, so I prefer this. 
