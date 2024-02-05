##########
#binomial - Q2a skeleton
library(boot)
data(nodal)
y = nodal$stage

#data manipulation
n = length(y)
s_n = sum(y)
f_n = n - s_n

#setting hyper-parameters
alpha_0 = 1.5
beta_0 = 8.5

#starting point
theta_0 = s_n/n
phi_0=NA

#Gibbs sampling
N_samps = 1e4
theta_curr = theta_0
phi_curr = phi_0

theta_draws = phi_draws = y_new_draws = rep(NA,N_samps)

for(i in 1:N_samps){
  prob = 0.5 #replace with proper probability calculation
  phi_curr = rbinom(1,1,prob)
  
  shape_1 = ifelse(phi_curr==0,1,1) #replace 1s with correct shapes, first is for phi=0, second is for phi=1
  shape_2 = ifelse(phi_curr==0,1,1) #replace 1s with correct shapes, first is for phi=0, second is for phi=1
  theta_curr = rbeta(1,shape_1,shape_2)
  
  phi_draws[i] = phi_curr
  theta_draws[i] = theta_curr
  y_new_draws[i] = rbinom(1,1,theta_curr)
}

##########
#poisson - Q2b skeleton
library(boot)
data(fir)
y = fir$count

#data manipulation
n = length(y)
s_n = sum(y)

#setting hyper-parameters
alpha_0 = alpha_1 = beta_0 = 1

#starting point
theta_0 = s_n/n
phi_0=NA

#Gibbs sampling
N_samps = 1e4
theta_curr = theta_0
phi_curr = phi_0

theta_draws = phi_draws = y_new_draws = rep(NA,N_samps)

for(i in 1:N_samps){
  shape_phi = 1 #replace with proper calculation
  rate_phi = 1 #replace with proper calculation
  phi_curr = rgamma(1,shape_phi,rate_phi)
  
  shape_theta = 1 #replace with proper calculation
  rate_theta = 1 #replace with proper calculation
  theta_curr = rgamma(1,shape_theta,rate_theta)
  
  phi_draws[i] = phi_curr
  theta_draws[i] = theta_curr
  y_new_draws[i] = rpois(1,theta_curr)
}

##########
#gamma - Q2c skeleton
library(boot)
data(poisons)
y = poisons$time
nu_0 = 4.31 #use fixed shape for gamma distribution for y

#loading package for rinvgauss
library(statmod)

#data manipulation
n = length(y)
s_n = sum(y)

#setting hyper-parameters
beta_0 = 1

#starting point
theta_0 = nu_0/(s_n/n)
phi_0=NA

#Gibbs sampling
N_samps = 1e4
theta_curr = theta_0
phi_curr = phi_0

theta_draws = phi_draws = y_new_draws = rep(NA,N_samps)

for(i in 1:N_samps){
  mean_phi = 1 #replace with proper calculation
  shape_phi = 1 
  phi_curr = rinvgauss(1,mean_phi,shape_phi)
  
  shape_theta = 1 #replace with proper calculation
  rate_theta = 1 #replace with proper calculation
  theta_curr = rgamma(1,shape_theta,rate_theta)
  
  phi_draws[i] = phi_curr
  theta_draws[i] = theta_curr
  y_new_draws[i] = rgamma(1,nu_0,theta_curr)
}

##########
#laplace - Q2d skeleton
library(boot)
data(acme)
y=acme$acme

#loading package for rinvgauss
library(statmod)

#defining function for rinvgamma
## rinvgamma definition
## simple Inverting of draws from appropriate gamma distribution
## parameterized using shape = delta and scale = zeta
rinvgamma = function(n,delta,zeta){
  shape = delta
  rate = zeta
  1/rgamma(n,shape,rate)
}


#data manipulation
n = length(y)

#setting hyper-parameters
a_0 = 0
b_0 = delta_0 = zeta_0 = 1

#starting point
mu_0 = median(y)
nu_0 = (mean(abs(y-mu_0)))^2
z_0 = rep(NA,n)


#Gibbs sampling
N_samps = 1e4
mu_curr = mu_0
nu_curr = nu_0
z_curr = z_0

mu_draws = nu_draws = y_new_draws = rep(NA,N_samps)

for(i in 1:N_samps){
  mean_z = rep(1,n) #replace with proper calculation
  shape_z = 1 
  z_curr = rinvgauss(n,mean_z,shape_z)
  
  mean_mu = 1 #replace with proper calculation
  var_mu = 1 #replace with proper calculation
  mu_curr = rnorm(1,mean_mu,sqrt(var_mu))
  
  shape_nu = 1 #replace with proper calculation
  scale_nu = 1 #replace with proper calculation
  nu_curr = rinvgamma(1,shape_nu,scale_nu)
  
  mu_draws[i] = mu_curr
  nu_draws[i] = nu_curr
  z_new = rinvgamma(1,1,0.5)
  y_new_draws[i] = rnorm(1,mu_curr,sqrt(nu_curr/z_new))
}

##########
#t lin mod - Q2e skeleton
library(palmerpenguins)
data("penguins")
y = penguins$flipper_length_mm
x = penguins$body_mass_g
ind = !(is.na(y)|is.na(x))
y = y[ind]
x = x[ind]

#defining function for rinvgamma
## rinvgamma definition
## simple Inverting of draws from appropriate gamma distribution
## parameterized using shape = delta and scale = zeta
rinvgamma = function(n,delta,zeta){
  shape = delta
  rate = zeta
  1/rgamma(n,shape,rate)
}


#data manipulation
n = length(y)

#setting hyper-parameters
a_0 = c_0 = 0
b_0 = 1e6
d_0 = delta_0 = zeta_0 = 1
k = 7

#setting prediction x value
x_new = 4200

#starting point
#we will use our best guess from the gaussian linear regression formulation
beta_0 = sd(y)/sd(x)*cor(x,y)
alpha_0 = mean(y-beta_0*x)
nu_0 = sum((y-alpha_0-beta_0*x)^2)/(n-2)
z_0 = rep(NA,n)


#Gibbs sampling
N_samps = 1e4
alpha_curr = alpha_0
beta_curr = beta_0
nu_curr = nu_0
z_curr = z_0

alpha_draws = beta_draws = nu_draws = y_new_draws = rep(NA,N_samps)

for(i in 1:N_samps){
  shape_z = rep(1,n) #replace with proper calculation
  rate_z = rep(1,n) #replace with proper calculation
  z_curr = rgamma(n,shape_z,rate_z)
  
  mean_alpha = 1 #replace with proper calculation
  var_alpha = 1 #replace with proper calculation
  alpha_curr = rnorm(1,mean_alpha,sqrt(var_alpha))

  mean_beta = 1 #replace with proper calculation
  var_beta = 1 #replace with proper calculation
  beta_curr = rnorm(1,mean_beta,sqrt(var_beta))
  
  shape_nu = 1 #replace with proper calculation
  scale_nu = 1 #replace with proper calculation
  nu_curr = rinvgamma(1,shape_nu,scale_nu)
  
  alpha_draws[i] = alpha_curr
  beta_draws[i] = beta_curr
  nu_draws[i] = nu_curr
  
  z_new = rgamma(1,k/2,k/2)
  y_new_draws[i] = rnorm(1,alpha_curr+beta_curr*x_new,sqrt(nu_curr/z_new))
}
