library(boot) #load package for later

#risk function
mean_rho = function(theta,y,delta=IQR(y)){
  mean(sqrt(delta^2+(y-theta)^2)) - delta
}
#estimating function
mean_psi = function(theta,y,delta=IQR(y)){
  -mean((y-theta)/sqrt(delta^2+(y-theta)^2))
}

#vectorized version of rho
V_mean_rho = Vectorize(mean_rho,vectorize.args = "theta")

#let's test it
y = rnorm(33)
theta = seq(-3,3,length.out=10)
mean_rho(theta,y)         #this throws a warning because the lengths of 
#y and theta do not "match" in some fashion
#the function is doing some repeating of
#theta values to match the number of y
#values and then averaging
#this is not what we want

V_mean_rho(theta,y=y)     #this gives the right output

#let's try it again, but where the length of theta
#is a multiple of the length of y
y = rnorm(5)
theta = seq(-3,3,length.out=10)
mean_rho(theta,y)         #this is wrong, we only get one number
#we got no warning about mismatched lengths
#so it seemed to work, but it did not
#the y values were repeated to match
#the number of theta values
#then the average was taken

V_mean_rho(theta,y=y)     #this gives the right output
#We can also call the vectorized version without naming y
#but naming additional arguments when we input them is better practice
V_mean_rho(theta,y)

#Vectorizing is really useful if we want to do things like plotting
y = rnorm(123)
theta = seq(-3,3,length.out = 1000)
risk = V_mean_rho(theta,y=y)
plot(risk~theta,main="Hyperbolic Risk",ylab="Risk",xlab=expression(theta),type="l")

#minimizing the risk using either the vectorized or non-vectorized version works
optimize(f=mean_rho,interval=range(y),y=y)
optimize(f=V_mean_rho,interval=range(y),y=y)

#Simlarly, vectorizing does not matter when we do root finding
V_mean_psi = Vectorize(mean_psi,vectorize.args = "theta")
uniroot(f=mean_psi,interval=range(y),y=y)
uniroot(f=V_mean_psi,interval=range(y),y=y)

#The minimizer of rho and the root of psi should be the same
#but they are slightly different because 
#of the default numerical accuracy of the two functions optimize and uniroot
#we can increase the accuracy by changing tolerances for stopping rules
optimize(f=mean_rho,interval=range(y),y=y,tol=.Machine$double.eps^0.5)
uniroot(f=mean_psi,interval=range(y),y=y,tol=.Machine$double.eps^0.5)

#We can also do this for non-default values of delta
optimize(f=mean_rho,interval=range(y),y=y,delta=0.5,tol=.Machine$double.eps^0.5)
uniroot(f=mean_psi,interval=range(y),y=y,delta=0.5,tol=.Machine$double.eps^0.5)

#of course, we could wrap these in functions and vectorize them over delta
est_fun_mean_rho = function(y,delta=IQR(y)){
  optimize(f=mean_rho,interval=range(y),y=y,delta=delta,tol=.Machine$double.eps^0.5)$minimum
}
V_est_fun_mean_rho = Vectorize(est_fun_mean_rho,vectorize.args = "delta")

#now we can use this to compute the estimator over a vector of delta values
delta = seq(0.01,30,length.out=1000)
est_vals = V_est_fun_mean_rho(y=y,delta=delta)
plot(est_vals~delta,type="l",main="Hyperbolic Risk Minimizers",
     xlab=expression(delta),ylab=expression(hat(theta)))

#of course, we need to restructure the est_fun_rho for use in boot
#We can actually make it use the function we wrote before
est_fun_mean_rho_bootable = function(y,ind=c(1:length(y)),delta=IQR(y)){
  y_rep = y[ind]
  est_fun_mean_rho(y_rep,delta)
}

#we can even write a function that uses the functions we have already written
#and outputs the estimate and bootstrap confidence interval
est_fun_mean_rho_with_boot_ci = function(y,delta=IQR(y),conf=0.95,R=10000){
  boot_out = boot(y,est_fun_mean_rho_bootable,delta=delta,R=R)
  boot.ci_out = boot.ci(boot_out,type="bca",conf=conf)
  est = boot_out$t0
  ci = boot.ci_out$bca[4:5]   #this is just where these outputs happen to be
  return(c(est=est,lower=ci[1],upper=ci[2]))
}
#test it using default values
est_fun_mean_rho_with_boot_ci(y)
#test it changing things up
est_fun_mean_rho_with_boot_ci(y,delta=0.5)
est_fun_mean_rho_with_boot_ci(y,conf=0.9)
est_fun_mean_rho_with_boot_ci(y,delta=3,conf=0.9)
#if we dare we could even vectorize this function over delta
V_est_fun_mean_rho_with_boot_ci = Vectorize(est_fun_mean_rho_with_boot_ci,vectorize.args = "delta")
#let's test it
V_est_fun_mean_rho_with_boot_ci(y=y,delta=c(1,2,4),conf=0.95)
#each column corresponds to a value of delta
#it is a good idea to change the column names of the output
#maybe just one more layer of wrapping (WHEN WILL IT STOP???)
final_est_fun_mean_rho_with_boot_ci = function(y,delta=IQR(y),conf=0.95){
  out = V_est_fun_mean_rho_with_boot_ci(y=y,delta=delta,conf=0.95)
  out = data.frame(delta=delta,t(out))
  return(out)
}
#test it!
final_est_fun_mean_rho_with_boot_ci(y,delta=c(0.5,1,4),0.95)
#one possible issue with this is that each delta value 
#uses different random bootstrap replicates
#this is probably a bad idea!

#we should think of a way to force them to use the same bootstrap replicates
#we just need to change where we did out vectorizing
#and the function that calls boot a bit
#there are lots of other ways we could have achieved this same goal
#this is one example
V_est_fun_mean_rho_bootable = 
  Vectorize(est_fun_mean_rho_bootable,
            vectorize.args = "delta")
final_est_fun_mean_rho_with_boot_ci_version_2 = function(y,delta=IQR(y),conf=0.95,R=10000){
  boot_out = boot(y,V_est_fun_mean_rho_bootable,delta=delta,R=R)
  ci = matrix(NA,length(delta),2)
  for(i in 1:length(delta)){
    ci[i,] = boot.ci(boot_out,type="bca",index=i,conf=conf)$bca[4:5]
  }
  return(data.frame(delta=delta,est=boot_out$t0,lower=ci[,1],upper=ci[,2]))
}
final_est_fun_mean_rho_with_boot_ci_version_2(y,delta=c(0.5,1,4))


