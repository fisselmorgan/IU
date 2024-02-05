####################################
## STAT S352
## Data Modeling and Inference
## Andrew Womack
####################################
## Shiny App
## Server File
## Two ways to get estimators
####################################

library(shiny)
library(boot)

## Functions for separating content and computation from formatting

##################
# Loading data
##################


data_list = list(acme = acme$acme,poisons = poisons$time,melanoma = melanoma$thickness,trees = trees$Height,gravity = gravity$g)
dens_list = list()
for(i in 1:5){if(i%in%c(2,3)){dens_list[[i]]=density(data_list[[i]],from=0)}else{dens_list[[i]]=density(data_list[[i]])}}
names(dens_list) = names(data_list)

h_mean = function(x){x}
h_median = function(x){1*(x!=0)*sign(x)}
h_huber = function(x,delta){ifelse(abs(x)<=delta,x,delta*sign(x))}
h_hyperbolic = function(x,delta){x/sqrt(delta^2+x^2)}
g_mean = function(x){x^2/2}
g_median = function(x){abs(x)}
g_huber = function(x,delta){ifelse(abs(x)<=delta,x^2/2,delta*abs(x)-delta^2/2)}
g_hyperbolic = function(x,delta){sqrt(delta^2+x^2)-delta}
get_inf_val_h = function(x,FUN,theta,...){
  f = function(theta,...){mean(FUN(x-theta,...))}
  Vf = Vectorize(f)
  Vf(theta,...)
}
get_inf_val_g = function(x,FUN,theta,...){
  f = function(theta,...){mean(FUN(x-theta,...))}
  Vf = Vectorize(f)
  Vf(theta,...)
}
get_est_h = function(x,FUN,...){
  f = function(theta,...){mean(FUN(x-theta,...))}
  Vf = Vectorize(f)
  uniroot(Vf,range(x),...)$root
}
get_est_g = function(x,FUN,...){
  f = function(theta,...){mean(FUN(x-theta,...))}
  Vf = Vectorize(f)
  optimize(Vf,range(x),...)$minimum
}
deltas_fun = function(x){
    # qu = quantile(x,seq(0.6,0.9,by=0.1))
    # ql = quantile(x,seq(0.1,0.4,by=0.1))
    # out = qu-ql[c(4:1)]
    # names(out) = paste0(seq(20,80,by=20),"%")
    # out[c(4:1)]
  out = quantile(x,.75) - quantile(x,.25)
  return(c(IQR=out))
}
deltas_list = lapply(data_list,deltas_fun)
names(deltas_list) = names(data_list)

stats_fun = function(x,ind = c(1:length(x)),deltas){
  x = x[ind]
  m = mean(x)
  v = mean((x-m)^2)
  s = sqrt(v)
  med = median(x)
  iqr = IQR(x)
  skew = mean((x-m)^3)/s^3
  kurt = mean((x-m)^4)/v^2
  est_h_mean = get_est_h(x = x, FUN = h_mean)
  est_h_median = get_est_h(x = x, FUN = h_median)
  est_h_huber_IQR = get_est_h(x = x, FUN = h_huber,delta = deltas[1])
  # est_h_huber_80 = get_est_h(x = x, FUN = h_huber,delta = deltas[1])
  # est_h_huber_60 = get_est_h(x = x, FUN = h_huber,delta = deltas[2])
  # est_h_huber_40 = get_est_h(x = x, FUN = h_huber,delta = deltas[3])
  # est_h_huber_20 = get_est_h(x = x, FUN = h_huber,delta = deltas[4])
  est_h_hyperbolic_IQR = get_est_h(x = x, FUN = h_hyperbolic,delta = deltas[1])
  # est_h_hyperbolic_80 = get_est_h(x = x, FUN = h_hyperbolic,delta = deltas[1])
  # est_h_hyperbolic_60 = get_est_h(x = x, FUN = h_hyperbolic,delta = deltas[2])
  # est_h_hyperbolic_40 = get_est_h(x = x, FUN = h_hyperbolic,delta = deltas[3])
  # est_h_hyperbolic_20 = get_est_h(x = x, FUN = h_hyperbolic,delta = deltas[4])
  est_g_mean = get_est_g(x = x, FUN = g_mean)
  est_g_median = get_est_g(x = x, FUN = g_median)
  est_g_huber_IQR = get_est_g(x = x, FUN = g_huber,delta = deltas[1])
  # est_g_huber_80 = get_est_g(x = x, FUN = g_huber,delta = deltas[1])
  # est_g_huber_60 = get_est_g(x = x, FUN = g_huber,delta = deltas[2])
  # est_g_huber_40 = get_est_g(x = x, FUN = g_huber,delta = deltas[3])
  # est_g_huber_20 = get_est_g(x = x, FUN = g_huber,delta = deltas[4])
  est_g_hyperbolic_IQR = get_est_g(x = x, FUN = g_hyperbolic,delta = deltas[1])
  # est_g_hyperbolic_80 = get_est_g(x = x, FUN = g_hyperbolic,delta = deltas[1])
  # est_g_hyperbolic_60 = get_est_g(x = x, FUN = g_hyperbolic,delta = deltas[2])
  # est_g_hyperbolic_40 = get_est_g(x = x, FUN = g_hyperbolic,delta = deltas[3])
  # est_g_hyperbolic_20 = get_est_g(x = x, FUN = g_hyperbolic,delta = deltas[4])
  
  
  return(c(mean=m,
           st_dev=s,
           skewness=skew,
           kurtosis=kurt,
           median = med,
           IQR = iqr,
           est_g_mean = est_g_mean,
           est_g_median = est_g_median,
           est_g_huber_IQR = est_g_huber_IQR,
           # est_g_huber_80 = est_g_huber_80,
           # est_g_huber_60 = est_g_huber_60,
           # est_g_huber_40 = est_g_huber_40,
           # est_g_huber_20 = est_g_huber_20,
           est_g_hyperbolic_IQR = est_g_hyperbolic_IQR,
           # est_g_hyperbolic_80 = est_g_hyperbolic_80,
           # est_g_hyperbolic_60 = est_g_hyperbolic_60,
           # est_g_hyperbolic_40 = est_g_hyperbolic_40,
           # est_g_hyperbolic_20 = est_g_hyperbolic_20,
           est_h_mean = est_h_mean,
           est_h_median = est_h_median,
           est_h_huber_IQR = est_h_huber_IQR,
           # est_h_huber_80 = est_h_huber_80,
           # est_h_huber_60 = est_h_huber_60,
           # est_h_huber_40 = est_h_huber_40,
           # est_h_huber_20 = est_h_huber_20,
           est_h_hyperbolic_IQR = est_h_hyperbolic_IQR
           # est_h_hyperbolic_80 = est_h_hyperbolic_80,
           # est_h_hyperbolic_60 = est_h_hyperbolic_60,
           # est_h_hyperbolic_40 = est_h_hyperbolic_40,
           # est_h_hyperbolic_20 = est_h_hyperbolic_20
           ))
}
boot_fun = function(ind_name){
  x = data_list[[ind_name]]
  deltas = deltas_list[[ind_name]]
  boot_out = boot(x,stats_fun,R=500,deltas=deltas)
  ci = matrix(NA,14,3)
  ci[,1] = boot_out$t0
  for(i in 1:14){
    ci[i,2:3] = boot.ci(boot_out,type="basic",index=i)$basic[4:5]
  }
  colnames(ci) = c("est","lower","upper")
  rownames(ci) = c("mean",
                   "st_dev",
                   "skewness",
                   "kurtosis",
                   "median",
                   "IQR",
                   "est_g_mean",
                   "est_g_median",
                   "est_g_huber_IQR",
                   # "est_g_huber_80",
                   # "est_g_huber_60",
                   # "est_g_huber_40",
                   # "est_g_huber_20",
                   "est_g_hyperbolic_IQR",
                   # "est_g_hyperbolic_80",
                   # "est_g_hyperbolic_60",
                   # "est_g_hyperbolic_40",
                   # "est_g_hyperbolic_20",
                   "est_h_mean",
                   "est_h_median",
                   "est_h_huber_IQR",
                   # "est_h_huber_80",
                   # "est_h_huber_60",
                   # "est_h_huber_40",
                   # "est_h_huber_20",
                   "est_h_hyperbolic_IQR"
                   # "est_h_hyperbolic_80",
                   # "est_h_hyperbolic_60",
                   # "est_h_hyperbolic_40",
                   # "est_h_hyperbolic_20"
                   )
  ci
}
boot_conf_intervals = lapply(names(data_list),boot_fun)
names(boot_conf_intervals) = names(data_list)

f_ee_theory = function(){
  xx = seq(-2,2,length=1000)
  yy_mean = h_mean(xx)
  yy_median = h_median(xx)
  yy_huber = h_huber(xx,1)
  yy_hyperbolic = h_hyperbolic(xx,1)
  return(list(x = xx, mean = yy_mean, median=yy_median,huber=yy_huber,hyperbolic=yy_hyperbolic))
}
ee_theory_list = f_ee_theory()

f_risk_theory = function(){
  xx = seq(-3,3,length=1000)
  yy_mean = g_mean(xx)
  yy_median = g_median(xx)
  yy_huber = g_huber(xx,1)
  yy_hyperbolic = g_hyperbolic(xx,1)
  return(list(x = xx, mean = yy_mean, median=yy_median,huber=yy_huber,hyperbolic=yy_hyperbolic))
}
risk_theory_list = f_risk_theory()

thetas_list = lapply(data_list,function(x){seq(quantile(x,.05),quantile(x,.95),length.out=1000)})
names(thetas_list) = names(data_list)

f_ee_inf = function(ind_name){
  theta = thetas_list[[ind_name]]
  x = data_list[[ind_name]]
  delta = deltas_list[[ind_name]]
  yy_mean = get_inf_val_h(x,h_mean,theta)
  yy_median = get_inf_val_h(x,h_median,theta)
  yy_huber = get_inf_val_h(x,h_huber,theta,delta=delta[1])
  yy_hyperbolic = get_inf_val_h(x,h_hyperbolic,theta,delta=delta[1])
  return(list(theta = theta, mean = yy_mean, median=yy_median,huber=yy_huber,hyperbolic=yy_hyperbolic))
}
ee_inf_list = lapply(names(data_list),f_ee_inf)
names(ee_inf_list) = names(data_list)
names_stats = c("mean","median","huber","hyperbolic")
ee_cis = lapply(boot_conf_intervals,function(x){x=x[7:10,];rownames(x)=names_stats;x})
names(ee_cis) = names(data_list)

f_risk_inf = function(ind_name){
  theta = thetas_list[[ind_name]]
  x = data_list[[ind_name]]
  delta = deltas_list[[ind_name]]
  yy_mean = get_inf_val_g(x,g_mean,theta)
  yy_median = get_inf_val_g(x,g_median,theta)
  yy_huber = get_inf_val_g(x,g_huber,theta,delta=delta[1])
  yy_hyperbolic = get_inf_val_g(x,g_hyperbolic,theta,delta=delta[1])
  return(list(theta = theta, mean = yy_mean, median=yy_median,huber=yy_huber,hyperbolic=yy_hyperbolic))
}
risk_inf_list = lapply(names(data_list),f_risk_inf)
names(risk_inf_list) = names(data_list)
risk_cis = lapply(boot_conf_intervals,function(x){x=x[11:14,];rownames(x)=names_stats;x})
names(risk_cis) = names(data_list)

supp_1 ={ 
  "The idea is to estimate a parameter $\\theta$ by making an expected value restriction.
  For a random variable $X$, we define the function $S(\\theta)$ by
  $$ 
  S(\\theta)\\ =\\ \\text{E}\\left[\\ \\psi\\left(X,\\ \\theta\\right)\\ \\right]
  $$
  I will refer to $\\psi$ as the $\\textbf{estimating function}$.
  The 'true' value of the parameter, $\\ \\theta^*$, satisfies the $\\textbf{estimating equation}$
  $$
  S\\left(\\theta^*\\right)\\ =\\ 0
  $$
  We estimate $S(\\theta)$ using observed data $x_1,\\ldots,x_n$ and an empirical average
  $$
  \\widehat{S}_n(\\theta)\\ =\\ \\frac{1}{n}\\sum_{i=1}^n\\ \\psi\\left(x_i,\\ \\theta\\right)
  $$
  Under fairly general settings, $\\psi$ satisfies the assumptions of the Law of Large Numbers and
  $$
  \\widehat{S}_n(\\theta)\\ \\stackrel{P}{\\longrightarrow}\\ S(\\theta)
  $$
  This motivates the estimate $\\widehat{\\theta}_n$ that satisfies the $\\textbf{empirical estimating equation}$
  $$
  \\widehat{S}_n\\left(\\widehat{\\theta}_n\\right)\\ =\\ 0 
  $$
  and we get (fairly generally)
  $$
  \\widehat{\\theta}_n
  \\ \\stackrel{P}{\\longrightarrow}\\ 
  \\theta^*
  $$
  and so we have a consistent estimator. Under further conditions, we get a Central Limit Theorem and can make statements about the asymptotic variance of the estimator (it is related to the variance and first derivative of $\\psi$).
  $$ $$
  There is an equivalence with risk minimization if
  $$
  S(\\theta) = \\frac{\\textrm{d}}{\\textrm{d} \\theta}\\  R(\\theta)
  $$
  and
  $$
  \\psi(x,\\ \\theta) = \\frac{\\partial}{\\partial \\theta}\\ \\rho(x,\\ \\theta)
  $$
  "
}
supp_2 = {
  "The idea is to estimate a parameter $\\theta$ by miniming an expected value.
  For a random variable $X$, we define the risk function $R(\\theta)$ by
  $$ 
  R(\\theta)\\ =\\ \\text{E}\\left[\\ \\rho\\left(X,\\ \\theta\\right)\\ \\right]
  $$
  I will refer to $\\rho$ as the $\\textbf{loss function}$.
  The 'true' value of the parameter, $\\ \\theta^*$, is the $\\textbf{risk minimizer}$ and is defined by
  $$
  \\theta^* \\ =\\ \\arg\\!\\min_{\\theta}\\  R\\left(\\theta\\right)
  $$
  We estimate $R(\\theta)$ using observed data $x_1,\\ldots,x_n$ by computing the $\\textbf{empirical risk function}$
  $$
  \\widehat{R}_n(\\theta)\\ = \\ \\frac{1}{n}\\sum_{i=1}^n\\ \\rho\\left(x_i,\\ \\theta\\right)
  $$
  Under fairly general settings, $\\rho$ satisfies the assumptions of the Law of Large Numbers and
  $$
  \\widehat{R}_n(\\theta)\\ \\stackrel{P}{\\longrightarrow}\\ R(\\theta)
  $$
  This motivates the estimate $\\widehat{\\theta}_n$ that is the $\\textbf{empirical risk minimizer}$ given by
  $$
  \\widehat{\\theta}_n\\ =\\ \\arg\\!\\min_{\\theta}\\ \\widehat{R}_n\\left(\\theta\\right)
  $$
  and we get (fairly generally)
  $$
  \\widehat{\\theta}_n
  \\ \\stackrel{P}{\\longrightarrow}\\ 
  \\theta^*
  $$
  and so we have a consistent estimator. Under further conditions, we get a Central Limit Theorem and can make statements about the asymptotic variance of the estimator (it is related to the first and second derivatives of $\\rho$).
  $$ $$
  There is an equivalence with estimating equations if
  $$
  R(\\theta) = \\int S(\\theta)\\ \\textrm{d}\\theta
  $$
  and
  $$
  \\rho(x,\\ \\theta) = \\int \\psi(x,\\ \\theta)\\ \\textrm{d}\\theta
  $$
  "
}
supp_3 = {
  "
  $\\textbf{Measures of Center}$ are defined using estimating equations or risk minimization using specific
  kinds of choices for $\\psi$ or $\\rho$. First, these functions are assumed to depend on just the difference between $x$ and $\\theta$
  $$
  \\begin{array}{rcl}
  \\psi(x,\\ \\theta) &=& h(x-\\theta)\\\\
  \\rho(x,\\ \\theta) &=& g(x-\\theta)
  \\end{array}
  $$
  Further it is assumed that $h$ is odd and that $g$ is even
  $$
  \\begin{array}{rcl}
  h(-t) &=& -h(t)\\\\
  g(-t) &=& g(t)
  \\end{array}
  $$
  The first assumption necessitates $h(0)=0$. 
  We should also assume that
  $$
  \\begin{array}{rcl}
  h(t) > 0 &\\text{for}&t>0\\\\
  \\min_t g(t) &=& g(0)
  \\end{array}
  $$
  The more restrictions we make on the $h$ or $g$, the better behaved our estimators will be. 
  The restrictions can also help with making numerical computation easier or guaranteeing unique solutions to equations. One such estimating equation assumption is that $h$ is non-decreasing or strictly increasing.
  A similar risk minimization assumption is that $g$ is convex, which means that $$a\\times g(t) + (1-a)\\times g(u)\\ \\geq\\ g\\left(at + (1-a)u\\right)$$ for all $(t,u)$ and $0\\leq a\\leq 1$. These restrictions are more easily stated when the functions are differentiable
  $$
  h^\\prime(t)\\geq 0 \\quad\\text{and}\\quad g^{\\prime\\prime}(t)\\geq 0
  $$
  and strict inequalities here make our lives easier.
  $$ $$
  There is an equivalence between estimators if we have $$h(t) = g^\\prime(t)$$ and so $$g(t) = \\int h(t)\\ \\textrm{d}t$$
  "
}

info_1 = function(dataset){
  if(dataset=="acme"){
    "
    This data is from the boot package dataset $\\textrm{acme}$. 
    The excess return for the Acme Cleveland Corporation are recorded along with those for all stocks listed on the New York and American Stock Exchanges were recorded over a five year period. These excess returns are relative to the return on a risk-less investment such a U.S. Treasury bills. 
    We are ignoring the market and month information and just looking at excess returns.
    The distribution appears approximately symmetric because the skewness cannot be said to be outside of $(-0.5,0.5)$ based on the $95\\%$ bootstrap CI. 
    The distribution cannot be said to be overdispersed because we cannot conclude that the kurtosis is greater than 3 based on the $95\\%$ bootstrap CI. 
    "
  }else if(dataset=="poisons"){
    "
    This data is from the boot package dataset $\\textrm{poisons}$. 
    The data form a 3x4 factorial experiment, the factors being three poisons and four treatments. Each combination of the two factors was used for four animals, the allocation to animals having been completely randomized. 
    We are ignoring the treatment and animal information and just looking at survival time.
    The distribution appears moderately right skewed because the $95\\%$ bootstrap CI is to the right of $0.5$ but not to the right of $1$. 
    The distribution cannot be said to be overdispersed because we cannot conclude that the kurtosis is greater than 3 based on the $95\\%$ bootstrap CI. 
    "
  }else if(dataset=="melanoma"){
    "
    This data is from the boot package dataset $\\textrm{melanoma}$. 
    The data consist of measurements made on patients with malignant melanoma. Each patient had their tumour removed by surgery at the Department of Plastic Surgery, University Hospital of Odense, Denmark during the period 1962 to 1977. The surgery consisted of complete removal of the tumour together with about 2.5cm of the surrounding skin. Among the measurements taken were the thickness of the tumour and whether it was ulcerated or not. These are thought to be important prognostic variables in that patients with a thick and/or ulcerated tumour have an increased chance of death from melanoma. Patients were followed until the end of 1977.
    We are ignoring are ignoring all information other than tumor thickness.
    The distribution appears highly right skewed because the $95\\%$ bootstrap CI is to the right $1$. 
    The distribution appears to be overdispersed because the $95\\%$ bootstrap CI for the kurtosis is to the right of 3. 
    "
  }else if(dataset=="trees"){
    "
    This data is from the boot package dataset $\\textrm{trees}$. 
    This data set provides measurements of the diameter, height and volume of timber in 31 felled black cherry trees. Note that the diameter (in inches) is erroneously labelled Girth in the data. It is measured at 4 ft 6 in above the ground.
    We are ignoring girth and volume information and just looking at height.
    The distribution appears approximately symmetric because the skewness cannot be said to be outside of $(-0.5,0.5)$ based on the $95\\%$ bootstrap CI. 
    The distribution cannot be said to be overdispersed because we cannot conclude that the kurtosis is greater than 3 based on the $95\\%$ bootstrap CI.
    "
  }else{
    "
    This data is from the boot package dataset $\\textrm{gravity}$. 
    Between May 1934 and July 1935, the National Bureau of Standards in Washington D.C. conducted a series of experiments to estimate the acceleration due to gravity, g, at Washington. Each experiment produced a number of replicate estimates of g using the same methodology. Although the basic method remained the same for all experiments, that of the reversible pendulum, there were changes in configuration. The data are expressed as deviations from 980.000 in centimetres per second squared.
    We are ignoring which experiment was being performed and just looking at the deviation of the measurement from $980\\ cm/s^2$.
    The distribution appears approximately symmetric because the skewness cannot be said to be outside of $(-0.5,0.5)$ based on the $95\\%$ bootstrap CI. 
    The distribution appears to be overdispersed because the $95\\%$ bootstrap CI for the kurtosis is to the right of 3. 
    "
  }
}
info_2 = function(statistic){
  if(statistic=="mean"){
    "
    The theoretical mean $\\theta^*$ satisfies the estimating equation
    $$
    \\text{E}\\left[X-\\theta^*\\right] = 0
    $$
    The estimating function for the mean is
    $$h(t) = t$$
    For observed data $x_1,\\ldots,x_n$ the estimate $\\widehat{\\theta}_n$ is given by the sample mean because it satisfies
    $$
    \\frac{1}{n} \\sum_{i=1}^n \\left(x_i-\\widehat{\\theta}_n\\right)\\ =\\ 0
    $$
    "
  }else if(statistic=="median"){
    "
    The theoretical median $\\theta^*$ satisfies the estimating equation
    $$
    \\text{E}\\left[\\textrm{sign}\\left(X-\\theta^*\\right)\\right] = 0
    $$
    for continuous distributions (such a $\\theta^*$ might not exist for discrete distributions).
    The estimating function for the median is thus
    $$h(t) = \\textrm{sign}(t) = 
    \\begin{cases}
    -1 & t< 0\\\\
    0 & t=0\\\\
    1 & t> 0
    \\end{cases}
    $$
    For observed data $x_1,\\ldots,x_n$ the estimate is given by any number $\\widehat{\\theta}_n$ that satisfies 
    $$
    \\frac{1}{n} \\sum_{i=1}^n \\textrm{sign}\\left(x_i-\\widehat{\\theta}_n\\right)\\ =\\ 0
    $$
    When $n$ is even, and so $n=2k$ for some $k$, the sample median is any number between the $k$ and $k+1$ ranked data values.
    When $n$ is odd, and so $n=2k+1$ for some $k$, the sample median is the $k+1$ ranked data value.
    "
  }else if(statistic=="huber"){
    "
    The theoretical value satisfying the Huber estimating equations $\\theta^*$ satisfies the estimating equation
    $$
    \\text{E}\\left[h_{\\delta}\\left(X-\\theta^*\\right)\\right] = 0
    $$
    where the estimating function for the Huber equations is
    $$h_{\\delta}(t) = 
    \\begin{cases}
    t & |t|\\leq\\delta\\\\
    \\delta\\, \\textrm{sign}(t) & |t|>\\delta
    \\end{cases}
    $$
    It is continuous and strikes a balance between linear (like the mean) and sign (like the median). The caliper $\\delta>0$ determines where the change occurs. 
    For observed data $x_1,\\ldots,x_n$ the estimate is given by any number $\\widehat{\\theta}_n$ that satisfies 
    $$
    \\frac{1}{n} \\sum_{i=1}^n h_{\\delta}\\left(x_i-\\widehat{\\theta}_n\\right)\\ =\\ 0
    $$
    The compromise between mean and median estimating functions makes the Huber estimator less susceptible to outliers than the mean but not as robust as the median.
    One possible advantage of the Huber estimator over the median is that the estimating function is continuous instead of discontinuous.
    "
  }else if(statistic=="hyperbolic"){
    "
    The theoretical value satisfying the hyperbolic estimating equations $\\theta^*$ satisfies the estimating equation
    $$
    \\text{E}\\left[\\frac{X-\\theta^*}{\\sqrt{ \\delta^2+\\left(X-\\theta^*\\right)^2}}\\right] = 0
    $$
    where the estimating function for the hyperbolic equation is
    $$h_{\\delta}(t) = 
    \\frac{t}{\\sqrt{ \\delta^2+t^2}}
    $$
    It is continuous and infinitely differentiable and strikes a balance between linear (like the mean) and sign (like the median). The scaling $\\delta>0$ determines where change occurs (though the change is gradual) and $\\delta/2$ is the value of $t$ where the curvature of $h_{\\delta}(t)$ is greatest in magnitude.
    For observed data $x_1,\\ldots,x_n$ the estimate is given by any number $\\widehat{\\theta}_n$ that satisfies 
    $$
    \\frac{1}{n} \\sum_{i=1}^n \\frac{x_i-\\widehat{\\theta}_n}{\\sqrt{ \\delta^2+\\left(x_i-\\widehat{\\theta}_n\\right)^2}}\\ =\\ 0
    $$
    The compromise between mean and median estimating functions makes the hyperbolic estimator less susceptible to outliers than the mean but not as robust as the median.
    One possible advantage of the hyperbolic estimator over the Huber estimator is that the estimating function is continuous continuous and infinitely differentiable instead of just continuous.
    "
  }else{
    "
    \\begin{array}{rl}
    Mean:& h(t) = t\\\\
    Median:& h(t) = \\textrm{sign}(t)\\\\
    Huber:& h_\\delta(t) = 
    \\begin{cases}
    t & |t|\\leq\\delta\\\\
    \\delta\\,\\textrm{sign}(t) & |t|>\\delta
    \\end{cases}
    \\\\
    Hyperbolic:& h_\\delta(t) = \\frac{t}{\\sqrt{ \\delta^2+t^2}}
    \\end{array}
    "
  }
}
info_3 = function(statistic){
  if(statistic=="mean"){
    "
    The theoretical mean $\\theta^*$ minimizes the risk
    $$
    R(\\theta)\\ = \\ \\text{E}\\left[\\frac{(X-\\theta)^2}{2}\\right]
    $$
    The loss function for the mean is
    $$g(t) = \\frac{t^2}{2}$$
    For observed data $x_1,\\ldots,x_n$ the estimate $\\widehat{\\theta}_n$ is given by the sample mean because it minimizes
    $$
    \\widehat{R}_n(\\theta)\\ = \\ \\frac{1}{n} \\sum_{i=1}^n \\frac{\\left(x_i - \\theta\\right)^2}{2}\\
    $$
    "
  }else if(statistic=="median"){
    "
    The theoretical median $\\theta^*$ minimizes the risk
    $$
    R(\\theta)\\ =\\ \\text{E}\\left[\\left|X-\\theta\\right|\\right]
    $$
    The loss function for the median is thus
    $$g(t) = |t|
    $$
    For observed data $x_1,\\ldots,x_n$ the estimate is given by the number $\\widehat{\\theta}_n$ that minimizes 
    $$
    \\widehat{R}_n(\\theta)\\ = \\ \\frac{1}{n} \\sum_{i=1}^n \\left|x_i -  \\theta\\right|
    $$
    "
  }else if(statistic=="huber"){
    "
    The theoretical value for $\\theta^*$ minimizes the Huber risk
    $$
    R_\\delta(\\theta)\\ =\\ \\text{E}\\left[g_{\\delta}\\left(X-\\theta^*\\right)\\right]
    $$
    where the loss function for the Huber risk is
    $$g_{\\delta}(t) = 
    \\begin{cases}
    \\frac{t^2}{2} & |t|\\leq\\delta\\\\
    \\delta\\,|t|-\\frac{\\delta^2}{2} & |t|>\\delta
    \\end{cases}
    $$
    It is continuous, once differentiable with continuous derivative, and compromises between squared error and absolute error loss.
    For observed data $x_1,\\ldots,x_n$ the estimate is given by the number $\\widehat{\\theta}_n$ that minimizes 
    $$
    \\widehat{R}_{n,\\delta}(\\theta)\\ = \\ \\frac{1}{n} \\sum_{i=1}^n g_{\\delta}\\left(x_i - \\theta\\right)
    $$
    The compromise between squared and absolute error loss makes the Huber estimator less susceptible to outliers than the mean but not as robust as the median.
    One possible advantage of the Huber estimator over the median is that the loss function is once differentiable.
    "
  }else if(statistic=="hyperbolic"){
    "
    The theoretical value for $\\theta^*$ minimizes the hyperbolic risk
    $$
    R_\\delta(\\theta)\\ =\\ \\text{E}\\left[\\sqrt{ \\delta^2+(X-\\theta)^2}-\\delta\\right]
    $$
    and so the hyperbolic loss function is
    $$g_{\\delta}(t) = 
    \\sqrt{ \\delta^2+t^2}-\\delta
    $$
    It is continuous, infinitely differentiable with continuous derivative, and compromises between squared error and absolute error loss.
    For observed data $x_1,\\ldots,x_n$ the estimate is given by the number $\\widehat{\\theta}_n$ that minimizes 
    $$
    \\widehat{R}_{n,\\delta}(\\theta)\\ = \\ \\frac{1}{n} \\sum_{i=1}^n \\sqrt{ \\delta^2+\\left(x_i - \\theta\\right)^2}-\\delta
    $$
    The compromise between squared and absolute error loss makes the hyperbolic estimator less susceptible to outliers than the mean but not as robust as the median.
    One possible advantage of the hyperbolic estimator over the Huber estimator is that the risk function is infinitely differentiable instead of just once differentiable.
    "
  }else{
    "
    \\begin{array}{rl}
    Mean:& g(t) = \\frac{t^2}{2}\\\\
    Median:& g(t) = |t|\\\\
    Huber:& g_\\delta(t) = 
    \\begin{cases}
    \\frac{t^2}{2} & |t|\\leq\\delta\\\\
    \\delta\\,|t|-\\frac{\\delta^2}{2} & |t|>\\delta
    \\end{cases}
    \\\\
    Hyperbolic:& g_\\delta(t) = \\sqrt{ \\delta^2+t^2}-\\delta
    \\end{array}
    "
  }
}


## Server function - inclusion of session as input is to allow for additional dynamic control of UIs (like slider bounds)
shinyServer(function(input, output, session) {
  y = eventReactive(input$dataset,{
    data_list[[input$dataset]]
  })
  dens_y = eventReactive(input$dataset,{
    dens_list[[input$dataset]]
  })
  conf_ints = eventReactive(input$dataset,{
    boot_conf_intervals[[input$dataset]]
  })
  output$plots = renderPlot({
    par(bg="lightcyan")
    if(input$plot_type=="data"){
      plot(dens_y(),lwd=3,main="",xlab="",ylab="")
      title(main="KDE of Data",cex.main=2)
      title(ylab="Density",cex.lab=2,line=2.5)
      title(xlab="x",cex.lab=2)
      par_usr = par('usr')
      xlim = par_usr[1:2]
      ylim = par_usr[3:4]
      ind_text = c(1:6)
      ci_loc = round(conf_ints()[ind_text,],2)
      nums = apply(ci_loc,1,function(x){paste0("=",x[1]," (",x[2],", ",x[3],")")})
      words = paste0(names(nums),nums)
      xx = ifelse(input$dataset=="trees",xlim[1],xlim[2])
      pos = ifelse(input$dataset=="trees",4,2)
      yy_low = ylim[1]+0.4*(ylim[2]-ylim[1])
      yy_high = ylim[1]+0.9*(ylim[2]-ylim[1])
      yy = seq(yy_high,yy_low,length.out=6)
      text(xx,yy,labels = words,pos=pos,cex = 1.5)
    }else if(input$plot_type=="estimating"){
      if(input$statistic!="all"){
        xx = ee_theory_list[["x"]]
        yy = ee_theory_list[[input$statistic]]
        plot(yy~xx,type="l",lwd=3,main="",xlab="",ylab="",ylim=c(-3,3))
        title(main="Estimating Function",cex.main=2)
        title(ylab="h(t)",cex.lab=2,line=2.5)
        title(xlab="t",cex.lab=2)
        abline(0,0,col="lightgray")
        lines(c(0,0),c(-3,3),col="lightgray")
        if(input$statistic %in% c("huber","hyperbolic")){
          par_usr = par('usr')
          xlim = par_usr[1:2]
          ylim = par_usr[3:4]
          xx = xlim[1]+0.05*(xlim[2]-xlim[1])
          yy = ylim[1]+0.9*(ylim[2]-ylim[1])
          text(xx,yy,labels = bquote(delta == 1),pos=4,cex = 1.5)
        }
      }else{
        xx = ee_theory_list[["x"]]
        yy = ee_theory_list
        plot(yy[[2]]~xx,type="l",lwd=3,main="",xlab="",ylab="",ylim=c(-2,2),col="orange")
        lines(yy[[3]]~xx,lwd=3,col="red",lty=2)
        lines(yy[[4]]~xx,lwd=3,col="blue",lty=3)
        lines(yy[[5]]~xx,lwd=3,col="purple",lty=4)
        title(main="Estimating Function",cex.main=2)
        title(ylab="h(t)",cex.lab=2,line=2.5)
        title(xlab="t",cex.lab=2)
        legend("bottomright",legend=c("Mean","Median","Huber","Hyperbolic"),col=c("orange","red","blue","purple"),lty=c(1:4),lwd=3,cex = 1.5)
        abline(0,0,col="lightgray")
        lines(c(0,0),c(-3,3),col="lightgray")
        par_usr = par('usr')
        xlim = par_usr[1:2]
        ylim = par_usr[3:4]
        xx = xlim[1]+0.05*(xlim[2]-xlim[1])
        yy = ylim[1]+0.9*(ylim[2]-ylim[1])
        text(xx,yy,labels = bquote(delta == 1),pos=4,cex = 1.5)
      }
    }else if(input$plot_type=="inference_ee"){
      if(input$statistic!="all"){
        xx = ee_inf_list[[input$dataset]][["theta"]]
        yy = ee_inf_list[[input$dataset]][[input$statistic]]
        plot(yy~xx,type="l",lwd=3,main="",xlab="",ylab="")
        title(main="Empirical Estimating Equation",cex.main=2)
        title(ylab=expression(widehat(S)[n]~"("~theta~")"),cex.lab=1.5,line=2)
        title(xlab=expression(theta),cex.lab=1.5)
        abline(0,0,col="lightgray")
        par_usr = par('usr')
        xlim = par_usr[1:2]
        ylim = par_usr[3:4]
        xx = ee_cis[[input$dataset]][input$statistic,1]
        lines(c(xx,xx),ylim,lty=2,lwd=3,col="green")
        if(input$statistic %in% c("huber","hyperbolic")){
          xx = xlim[1]+0.05*(xlim[2]-xlim[1])
          yy = ylim[1]+0.3*(ylim[2]-ylim[1])
          text(xx,yy,labels = bquote(delta == .(round(deltas_list[[input$dataset]],2))),pos=4,cex = 1.5)
        }
        xx = xlim[1]+0.05*(xlim[2]-xlim[1])
        yy = ylim[1]+0.2*(ylim[2]-ylim[1])
        ci_loc = ee_cis[[input$dataset]][input$statistic,]
        text(xx,yy,labels = bquote(widehat(theta)[n] == .(round(ci_loc[1],2)) ~ "(" ~ .(round(ci_loc[2],2)) ~ ", " ~ .(round(ci_loc[3],2)) ~ ")"),pos=4,cex = 1.5)
        legend("topright",legend=expression(widehat(S)[n]~"("~theta~")",widehat(theta)[n]),col=c("black","green"),lty=c(1:2),lwd=3,cex = 1.5)
      }else{
        xx = ee_inf_list[[input$dataset]][["theta"]]
        yy = ee_inf_list[[input$dataset]]
        vv = yy[[2]]; vv = vv/(max(vv)-min(vv))
        plot(vv~xx,type="l",lwd=3,main="",xlab="",ylab="",col="orange",ylim=c(-0.6,0.5))
        vv = yy[[3]]; vv = vv/(max(vv)-min(vv))
        lines(vv~xx,lwd=3,col="red",lty=2)
        vv = yy[[4]]; vv = vv/(max(vv)-min(vv))
        lines(vv~xx,lwd=3,col="blue",lty=3)
        vv = yy[[5]]; vv = vv/(max(vv)-min(vv))
        lines(vv~xx,lwd=3,col="purple",lty=4)
        legend("topright",legend=c("Mean","Median","Huber","Hyperbolic"),col=c("orange","red","blue","purple"),lty=c(1:4),lwd=3,cex = 1.5)
        title(main="Empirical Estimating Equation",cex.main=2)
        title(ylab=expression(widehat(S)[n]~"("~theta~") [scaled]"),cex.lab=1.5,line=2)
        title(xlab=expression(theta),cex.lab=1.5)
        abline(0,0,col="lightgray")
        par_usr = par('usr')
        xlim = par_usr[1:2]
        ylim = par_usr[3:4]
        xx = xlim[1]+0.05*(xlim[2]-xlim[1])
        yy = ylim[1]+0.3*(ylim[2]-ylim[1])
        text(xx,yy,labels = bquote(delta == .(round(deltas_list[[input$dataset]],2))),pos=4,cex = 1.5)
      }
    }else if(input$plot_type=="loss"){
      if(input$statistic!="all"){
        xx = risk_theory_list[["x"]]
        yy = risk_theory_list[[input$statistic]]
        plot(yy~xx,type="l",lwd=3,main="",xlab="",ylab="",ylim=c(0,4.5))
        title(main="Loss Function",cex.main=2)
        title(ylab="g(t)",cex.lab=2,line=2.5)
        title(xlab="t",cex.lab=2)
        abline(0,0,col="lightgray")
        lines(c(0,0),c(-3,3),col="lightgray")
        if(input$statistic %in% c("huber","hyperbolic")){
          par_usr = par('usr')
          xlim = par_usr[1:2]
          ylim = par_usr[3:4]
          xx = xlim[1]+0.05*(xlim[2]-xlim[1])
          yy = ylim[1]+0.9*(ylim[2]-ylim[1])
          text(xx,yy,labels = bquote(delta == 1),pos=4,cex = 1.5)
        }
      }else{
        xx = risk_theory_list[["x"]]
        yy = risk_theory_list
        plot(yy[[2]]~xx,type="l",lwd=3,main="",xlab="",ylab="",ylim=c(0,4.5),col="orange")
        lines(yy[[3]]~xx,lwd=3,col="red",lty=2)
        lines(yy[[4]]~xx,lwd=3,col="blue",lty=3)
        lines(yy[[5]]~xx,lwd=3,col="purple",lty=4)
        title(main="Loss Function",cex.main=2)
        title(ylab="g(t)",cex.lab=2,line=2.5)
        title(xlab="t",cex.lab=2)
        legend("top",legend=c("Mean","Median","Huber","Hyperbolic"),col=c("orange","red","blue","purple"),lty=c(1:4),lwd=3,cex = 1.5)
        abline(0,0,col="lightgray")
        lines(c(0,0),c(-3,3),col="lightgray")
        par_usr = par('usr')
        xlim = par_usr[1:2]
        ylim = par_usr[3:4]
        xx = xlim[1]+0.05*(xlim[2]-xlim[1])
        yy = ylim[1]+0.9*(ylim[2]-ylim[1])
        text(xx,yy,labels = bquote(delta == 1),pos=4,cex = 1.5)
      }
    }else if(input$plot_type=="inference_risk"){
      if(input$statistic!="all"){
        xx = risk_inf_list[[input$dataset]][["theta"]]
        yy = risk_inf_list[[input$dataset]][[input$statistic]]
        plot(yy~xx,type="l",lwd=3,main="",xlab="",ylab="")
        title(main="Empirical Risk Function",cex.main=2)
        title(ylab=expression(widehat(R)[n]~"("~theta~")"),cex.lab=1.5,line=2)
        title(xlab=expression(theta),cex.lab=1.5)
        abline(min(yy),0,col="lightgray")
        par_usr = par('usr')
        xlim = par_usr[1:2]
        ylim = par_usr[3:4]
        xx = risk_cis[[input$dataset]][input$statistic,1]
        lines(c(xx,xx),ylim,lty=2,lwd=3,col="green")
        if(input$statistic %in% c("huber","hyperbolic")){
          xx = xlim[1]+0.05*(xlim[2]-xlim[1])
          yy = ylim[1]+0.9*(ylim[2]-ylim[1])
          text(xx,yy,labels = bquote(delta == .(round(deltas_list[[input$dataset]],2))),pos=4,cex = 1.5)
        }
        xx = xlim[1]+0.05*(xlim[2]-xlim[1])
        yy = ylim[1]+0.8*(ylim[2]-ylim[1])
        ci_loc = risk_cis[[input$dataset]][input$statistic,]
        text(xx,yy,labels = bquote(widehat(theta)[n] == .(round(ci_loc[1],2)) ~ "(" ~ .(round(ci_loc[2],2)) ~ ", " ~ .(round(ci_loc[3],2)) ~ ")"),pos=4,cex = 1.5)
        legend("bottomright",legend=expression(widehat(R)[n]~"("~theta~")",widehat(theta)[n]),col=c("black","green"),lty=c(1:2),lwd=3,cex = 1.5)
      }else{
        xx = risk_inf_list[[input$dataset]][["theta"]]
        yy = risk_inf_list[[input$dataset]]
        vv = yy[[2]]; vv = vv-min(vv); vv = vv/max(vv)
        plot(vv~xx,type="l",lwd=3,main="",xlab="",ylab="",col="orange")
        vv = yy[[3]]; vv = vv-min(vv); vv = vv/max(vv)
        lines(vv~xx,lwd=3,col="red",lty=2)
        vv = yy[[4]]; vv = vv-min(vv); vv = vv/max(vv)
        lines(vv~xx,lwd=3,col="blue",lty=3)
        vv = yy[[5]]; vv = vv-min(vv); vv = vv/max(vv)
        lines(vv~xx,lwd=3,col="purple",lty=4)
        legend("bottomright",legend=c("Mean","Median","Huber","Hyperbolic"),col=c("orange","red","blue","purple"),lty=c(1:4),lwd=3,cex = 1.5)
        title(main="Empirical Risk Function",cex.main=2)
        title(ylab=expression(widehat(R)[n]~"("~theta~") [shifted and scaled]"),cex.lab=1.5,line=2)
        title(xlab=expression(theta),cex.lab=1.5)
        abline(0,0,col="lightgray")
        par_usr = par('usr')
        xlim = par_usr[1:2]
        ylim = par_usr[3:4]
        xx = xlim[1]+0.05*(xlim[2]-xlim[1])
        yy = ylim[1]+0.9*(ylim[2]-ylim[1])
        text(xx,yy,labels = bquote(delta == .(round(deltas_list[[input$dataset]],2))),pos=4,cex = 1.5)
      }
    }
  })
  output$supp_1 = renderUI({withMathJax(supp_1)})
  output$supp_2 = renderUI({withMathJax(supp_2)})
  output$supp_3 = renderUI({withMathJax(supp_3)})
  output$info_1 = renderUI({withMathJax(info_1(input$dataset))})
  output$info_2 = renderUI({withMathJax(info_2(input$statistic))})
  output$info_3 = renderUI({withMathJax(info_3(input$statistic))})
})
