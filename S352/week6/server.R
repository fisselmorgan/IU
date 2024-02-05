####################################
## STAT S352
## Data Modeling and Inference
## Andrew Womack
####################################
## Shiny App 6
## Server File
## Likelihood Ratio Test
####################################

library(shiny)


## Functions for separating content and computation from formatting

##################
# Loading data
##################

N = 1000

obs_samp_fun = function(model,n,theta){
  if(model=="gaussian"){
    rnorm(n,theta)
  }else if(model=="bernoulli"){
    rbinom(n,1,theta)
  }else if(model=="poisson"){
    rpois(n,theta)
  }else{
    rgamma(n,theta)
  }
}
lambda_dist_fun = function(model,n,theta){
  if(model=="gaussian"){
    apply(matrix(rnorm(n*N,theta),n,N),2,function(x){n*mean(x)^2})
  }else if(model=="bernoulli"){
    apply(matrix(rbinom(n*N,1,theta),n,N),2,
          function(x){
            xb=mean(x);
            if(xb%in%c(0,1)){
              return(0)
              }else{
                return(2*n*(xb*log(2*xb)+(1-xb)*log(2*(1-xb))))
              }
            }
          )
  }else if(model=="poisson"){
    apply(matrix(rpois(n*N,theta),n,N),2,
          function(x){
            xb = mean(x)
            2*n*(xb*log(xb/2.5)-xb+2.5)
          })
  }else{
    apply(matrix(rgamma(n*N,theta),n,N),2,
          function(x){
            mlx = mean(log(x))
            lmx = log(mean(x))
            f = function(aa){a = exp(aa); digamma(a)-log(a)-mlx+lmx}
            aa = uniroot(f,c(-10,10),tol=1e-8)$root
            a = exp(aa)
            2*n*(a*log(a)+(a-1)*mlx-lgamma(a)-a-(a-1)*lmx+1)
          }
          )
  }
}
loglikfun = function(theta,model,y,mle){
  if(model=="gaussian"){
    sum(dnorm(y,theta,log=TRUE))
  }else if(model=="bernoulli"){
    sum(dbinom(y,1,theta,log=TRUE))
  }else if(model=="poisson"){
    sum(dpois(y,theta,log=TRUE))
  }else{
    sum(dgamma(y,theta,theta/mean(y),log=TRUE))
  }
}
V_loglikfun = Vectorize(loglikfun,vectorize.args = "theta")
mle_fun = function(x,model){
  if(model=="gaussian"){
    mean(x)
  }else if(model=="bernoulli"){
    mean(x)
  }else if(model=="poisson"){
    mean(x)
  }else{
    mlx = mean(log(x))
    lmx = log(mean(x))
    f = function(aa){a = exp(aa); digamma(a)-log(a)-mlx+lmx}
    aa = uniroot(f,c(-10,10),tol=1e-8,extendInt = "yes")$root
    a = exp(aa)
    b = a/mean(x)
    c(a=a,b=b)
  }
}
theta_0_fun = function(model){
  if(model=="gaussian"){
    0
  }else if(model=="bernoulli"){
    0.5
  }else if(model=="poisson"){
    2.5
  }else{
    1
  }
}

x_chi_sq = seq(1e-2,3,length.out = 1000)
y_chi_sq = dchisq(x_chi_sq,1)
chi_sq_dens_fun_samp = function(x){
  d = density(log(x))
  xx = exp(d$x)
  yy = d$y/xx
  cbind(x=xx,y=yy)
}


supp_1 ={ 
  "
  Data:
  $$\\mathbf{y}=(y_1,\\ldots,y_n)$$
  Parameter:
  $$\\theta\\in\\Theta$$
  Null hypothesis:
  $$H_0:\\theta\\in\\Theta_0\\subset\\Theta$$
  Alternative hypothesis:
  $$H_A:\\theta\\in\\Theta_0^C = \\Theta\\setminus\\Theta_0$$
  Rejection Region:
  $$\\text{reject }H_0\\text{ if } \\mathbf{y}\\in \\mathcal{R}_n$$
  Point Null:
  $$\\Theta_0=\\{\\theta_0\\}$$
  Test Statistic:
  $$\\text{reject }H_0\\text{ if } T(\\mathbf{y})\\in \\mathcal{R}_n$$
  $\\qquad$usually based on a critical value
  $$T(\\mathbf{y})>c_n$$
  "
}
supp_2 = {"
  Power function:
  $$
  \\begin{array}{rcl}
  \\pi(\\theta) &=& P(\\text{Reject }H_0;\\theta)
  \\\\&=& P(\\mathbf{y}\\in \\mathcal{R}_n;\\theta)
  \\end{array}
  $$
  Significance Level (Type I Error Rate):
  $$
  \\alpha = \\max_{\\theta\\in\\Theta_0} \\pi(\\theta)
  $$
  Type II Error Rate ($\\theta\\in\\Theta_0^C$):
  $$\\beta(\\theta) = 1-\\pi(\\theta)$$
  Point Null ($\\Theta_0=\\{\\theta_0\\}$):
  $$
  \\alpha = \\pi(\\theta_0)
  $$
  Test Statistic ($T(\\mathbf{y})$):
  $$
  \\alpha = \\max_{\\theta\\in\\Theta_0}P(T(\\mathbf{y})>c_n;\\theta)
  $$
  $\\qquad$with point null
  $$
  \\alpha = P(T(\\mathbf{y})>c_n;\\theta_0)
  $$
  $\\qquad$and Type II Error Rate ($\\theta\\in\\Theta_0^C$)
  $$
  \\beta(\\theta) = P(T(\\mathbf{y})\\leq c_n;\\theta)
  $$
"}
supp_3 = {"
  Likelihood:
  $$
  L(\\theta;\\mathbf{y}) = f(\\mathbf{y};\\theta)
  $$
  Maximized Likelihood under constrained versus full space:
  $$
  \\Lambda(\\mathbf{y})
  =
  \\frac{
  \\max_{\\theta\\in\\Theta_0} L(\\theta)
  }{
  \\max_{\\theta\\in\\Theta} L(\\theta)
  }
  $$
  We know $$0\\leq\\Lambda(\\mathbf{y})\\leq 1$$
  If $\\Lambda(\\mathbf{y})$ is too small then we reject the null hypothesis.
  $$
  \\mathcal{R}_n = \\{\\Lambda(\\mathbf{y})\\leq d_n\\}
  $$
  Point Null ($\\{\\theta_0\\}$) with Connected, Open $\\Theta$:
  $$
  \\begin{array}{rcl}
  0<&\\Lambda(\\mathbf{y})&<1\\\\
  \\lambda(\\mathbf{y}) &=& -2\\log(\\Lambda(\\mathbf{y}))\\\\
  \\lambda(\\mathbf{y})&>& c_n
  \\end{array}
  $$
  $\\textbf{Wilks' Theorem}$ (Point or subspace null hypothesis):
  $$
  \\lambda(\\mathbf{y})\\stackrel{D}{\\longrightarrow} X\\sim \\chi^2_d
  $$
  when the null is true and 
  where $d$ is the dimension of $\\Theta$ (or difference in dimensions). $\\chi^2$ (degrees of freedom $=d$) density is
  $$
  f_{\\chi^2}(x;d) = \\frac{x^{\\frac{d}{2}-1}}{2^{\\frac{d}{2}-1}
  \\Gamma\\left(\\frac{d}{2}\\right)}
  \\exp\\left(-\\frac{x}{2}\\right)
  $$
  If $Z_1,\\ldots,Z_d\\stackrel{iid}{\\longrightarrow}N(0,1)$ then
  $$
  (Z_1^2+\\cdots+Z_d^2)\\sim\\chi^2_d 
  $$
"}

info_1 = function(model){
  if(model=="gaussian"){
    "
    The model is that
    $$
    y_i\\stackrel{iid}{\\sim}N(\\theta,1)
    $$
    The null hypothesis is
    $$H_0:\\ \\theta=0$$
    The alternative hypothesis is
    $$H_A:\\ \\theta\\neq 0$$
    The density of a single $y$ is
    $$f(y;\\theta) = \\frac{1}{\\sqrt{2\\pi}}\\exp\\left(-\\frac{(y-\\theta)^2}{2}\\right)$$
    The log-likelihood is
    $$\\ell(\\theta;\\mathbf{y})= -\\frac{n}{2}\\log(2\\pi) - \\sum_{i=1}^n \\frac{(y_i-\\theta)^2}{2}$$
    The MLE is
    $$\\widehat{\\theta} = \\frac{y_1+\\cdots+y_n}{n} = \\overline{y}$$
    "
  }else if(model=="bernoulli"){
    "
    The model is that
    $$
    y_i\\stackrel{iid}{\\sim}Bernoulli(\\theta)
    $$
    The null hypothesis is
    $$H_0:\\ \\theta=0.5$$
    The alternative hypothesis is
    $$H_A:\\ \\theta\\neq 0.5$$
    The density of a single $y$ is
    $$
    f(y;\\theta) = \\theta^{y}(1-\\theta)^{1-y}
    $$
    The log-likelihood is
    $$
    \\ell(\\theta;\\mathbf{y})= \\sum_{i=1}^n 
    \\left[
    y_i\\log\\left(\\theta\\right)+(1-y_i)\\log\\left(1-\\theta\\right)
    \\right]
    $$
    The MLE is
    $$\\widehat{\\theta} = \\frac{y_1+\\cdots+y_n}{n} = \\overline{y}$$
    "
  }else if(model=="poisson"){
    "
    The model is that
    $$
    y_i\\stackrel{iid}{\\sim}Poisson(\\theta)
    $$
    The null hypothesis is
    $$H_0:\\ \\theta=2.5$$
    The alternative hypothesis is
    $$H_A:\\ \\theta\\neq 2.5$$
    The density of a single $y$ is
    $$
    f(y;\\theta) = \\frac{\\theta^{y}}{y!}\\exp(-\\theta)
    $$
    The log-likelihood is
    $$
    \\ell(\\theta;\\mathbf{y})= 
    \\sum_{i=1}^n 
    \\left[
    y_i\\log\\left(\\theta\\right)+\\log(y_i!)-\\theta
    \\right]
    $$
    The MLE is
    $$\\widehat{\\theta} = \\frac{y_1+\\cdots+y_n}{n} = \\overline{y}$$
    "
  }else{
    "
    The model is that
    $$
    y_i\\stackrel{iid}{\\sim}Gamma(\\theta,rate=\\beta)
    $$
    The null hypothesis is and Exponential Distribution
    $$H_0:\\ \\theta=1$$
    The alternative hypothesis is
    $$H_A:\\ \\theta\\neq 1$$
    The density of a single $y$ is
    $$
    f(y;\\theta,\\beta) = \\frac{\\beta^\\theta y^{\\theta-1}}{\\Gamma(\\theta)}\\exp(-\\beta y)
    $$
    The log-likelihood is
    $$
    \\begin{array}{rcl}
    \\ell(\\theta,\\beta;\\mathbf{y})&=& 
    \\sum_{i=1}^n 
    \\left[
    \\theta\\log\\left(\\beta\\right)+(\\theta-1)\\log\\left(y_i\\right)
    \\right.
    \\\\&&\\qquad\\left.
    -\\log(\\Gamma(\\theta))-\\beta y_i
    \\right]
    \\end{array}
    $$
    The MLE satisfies
    $$
    \\begin{array}{rcl}
    \\psi\\left(\\widehat{\\theta}\\right) -\\log\\left(\\widehat{\\theta}\\right) 
    &=&
    \\frac{1}{n}\\sum_{i=1}^n\\log(y_i) - \\log\\left(\\overline{y}\\right)
    \\\\
    \\widehat{\\beta} &=& \\frac{\\widehat{\\theta}}{\\overline{y}}
    \\end{array}
    $$
    where $\\psi()$ is the digamm function.
    "
  }
}
info_2 = function(model){
  if(model=="gaussian"){
    "
    The log-likelihood evaluated at the MLE is
    $$
    \\ell\\left(\\widehat{\\theta};\\mathbf{y}\\right)= 
    -\\frac{n}{2}\\log(2\\pi) - 
    \\sum_{i=1}^n \\frac{\\left(y_i-\\overline{y}\\right)^2}{2}
    $$
    The log-likelihood evaluated at the null is
    $$
    \\ell\\left(0;\\mathbf{y}\\right)= 
    -\\frac{n}{2}\\log(2\\pi) - 
    \\sum_{i=1}^n \\frac{\\left(y_i-0\\right)^2}{2}
    $$
    Twice the difference in log-likelihoods is
    $$
    \\lambda(\\mathbf{y})
    =
    \\sum_{i=1}^n \\left(y_i-0\\right)^2
    -
    \\sum_{i=1}^n \\left(y_i-\\overline{y}\\right)^2
    = n\\left(\\overline{y}\\right)^2
    $$
    The statistic $\\sqrt{n}\\times\\overline{y}\\sim N(0,1)$ when the null is true and so
    $$
    \\lambda(\\mathbf{y})\\stackrel{D}{\\longrightarrow}\\chi^2_1
    $$
    when the null is true
    "
  }else if(model=="bernoulli"){
    "
    The log-likelihood evaluated at the MLE is
    $$
    \\ell\\left(\\widehat{\\theta};\\mathbf{y}\\right)=
    \\sum_{i=1}^n 
    \\left[
    y_i\\log\\left(\\overline{y}\\right)+(1-y_i)\\log\\left(1-\\overline{y}\\right)
    \\right]
    $$
    The log-likelihood evaluated at the null is
    $$
    \\ell(0.5;\\mathbf{y})= \\sum_{i=1}^n 
    \\left[
    y_i\\log\\left(0.5\\right)+(1-y_i)\\log\\left(1-0.5\\right)
    \\right]
    $$
    Twice the difference in log-likelihoods is
    $$
    \\begin{array}{rcl}
    \\lambda(\\mathbf{y})
    &=& 2\\sum_{i=1}^n 
    \\left[
    y_i\\log\\left(\\frac{\\overline{y}}{0.5}\\right)+(1-y_i)\\log\\left(\\frac{1-\\overline{y}}{0.5}\\right)
    \\right]
    \\\\&=& 2n\\left[
    \\overline{y}\\log\\left(\\frac{\\overline{y}}{0.5}\\right)+\\left(1-\\overline{y}\\right)\\log\\left(\\frac{1-\\overline{y}}{0.5}\\right)
    \\right]
    \\end{array}
    $$
    The test statistic is quite weird looking, but when the null is true we get
    $$
    \\lambda(\\mathbf{y})\\stackrel{D}{\\longrightarrow}\\chi^2_1
    $$
    "
  }else if(model=="poisson"){
    "
    The log-likelihood evaluated at the MLE is
    $$
    \\ell\\left(\\widehat{\\theta};\\mathbf{y}\\right)= 
    \\sum_{i=1}^n 
    \\left[
    y_i\\log\\left(\\overline{y}\\right)+\\log(y_i!)-\\overline{y}
    \\right]
    $$
    The log-likelihood evaluated at the null is
    $$
    \\ell\\left(2.5;\\mathbf{y}\\right)= 
    \\sum_{i=1}^n 
    \\left[
    y_i\\log\\left(2.5\\right)+\\log(y_i!)-2.5
    \\right]
    $$
    Twice the difference in log-likelihoods is
    $$
    \\begin{array}{rcl}
    \\lambda(\\mathbf{y})
    &=& 2\\sum_{i=1}^n 
    \\left[
    y_i\\log\\left(\\frac{\\overline{y}}{2.5}\\right)-\\overline{y}+2.5
    \\right]
    \\\\&=& 2n\\left[
    \\overline{y}\\log\\left(\\frac{\\overline{y}}{2.5}\\right)-\\overline{y}+2.5
    \\right]
    \\end{array}
    $$
    The test statistic is quite weird looking, but when the null is true we get
    $$
    \\lambda(\\mathbf{y})\\stackrel{D}{\\longrightarrow}\\chi^2_1
    $$
    "
  }else{
    "
    The log-likelihood evaluated at the MLE is
    $$
    \\begin{array}{rcl}
    \\ell\\left(
    \\widehat{\\theta},\\frac{\\widehat{\\theta}}{\\overline{y}};\\mathbf{y}\\right)&=& 
    \\sum_{i=1}^n 
    \\left[
    \\widehat{\\theta}\\log\\left(\\frac{\\widehat{\\theta}}{\\overline{y}}\\right)+\\left(\\widehat{\\theta}-1\\right)\\log\\left(y_i\\right)
    \\right.
    \\\\&&\\qquad\\left.
    -\\log\\left(\\Gamma\\left(\\widehat{\\theta}\\right)\\right)- \\frac{\\widehat{\\theta}}{\\overline{y}}y_i
    \\right]
    \\end{array}
    $$
    The log-likelihood evaluated at the null is
    $$
    \\begin{array}{rcl}
    \\ell\\left(
    1,\\frac{1}{\\overline{y}};\\mathbf{y}\\right)&=& 
    \\sum_{i=1}^n 
    \\left[
    \\log\\left(\\frac{1}{\\overline{y}}\\right)+\\left(1-1\\right)\\log\\left(y_i\\right)
    \\right.
    \\\\&&\\qquad\\left.
    -\\log\\left(\\Gamma\\left(1\\right)\\right)- \\frac{1}{\\overline{y}}y_i
    \\right]
    \\end{array}
    $$
    Twice the difference in log-likelihoods is
    $$
    \\begin{array}{rcl}
    \\lambda(\\mathbf{y})
    &=& 
    2\\sum_{i=1}^n 
    \\left[
    \\widehat{\\theta}\\log\\left(\\frac{\\widehat{\\theta}}{\\overline{y}}\\right)+\\left(\\widehat{\\theta}-1\\right)\\log\\left(y_i\\right)
    \\right.
    \\\\&&\\qquad\\left.
    -\\log\\left(\\Gamma\\left(\\widehat{\\theta}\\right)\\right)- \\frac{\\widehat{\\theta}}{\\overline{y}}y_i
    \\right.
    \\\\&&\\qquad\\left.
    -
    \\log\\left(\\frac{1}{\\overline{y}}\\right)
    +\\frac{y_i}{\\overline{y}}
    \\right]
    \\\\
    &=& 
    2n 
    \\left[
    \\widehat{\\theta}\\log\\left(\\widehat{\\theta}\\right)+
    \\left(\\widehat{\\theta}-1\\right)\\overline{\\log\\left(y\\right)}
    \\right.
    \\\\&&\\qquad\\left.
    -\\log\\left(\\Gamma\\left(\\widehat{\\theta}\\right)\\right)- \\widehat{\\theta}
    \\right.
    \\\\&&\\qquad\\left.
    -
    \\left(\\widehat{\\theta}-1\\right)
    \\log\\left(\\overline{y}\\right)
    +1
    \\right]
    \\end{array}
    $$
    The test statistic is exquisitely strange looking, but when the null is true we get
    $$
    \\lambda(\\mathbf{y})\\stackrel{D}{\\longrightarrow}\\chi^2_1
    $$
    "
  }
}
info_3 = {
  "
  This is the most basic $\\textbf{Information Criterion}$.
  We compute the maximum log-likelihood for $iid$ data
  $$
  \\ell\\left(\\widehat{\\theta};\\mathbf{y}\\right) = \\sum_{i=1}^n \\log\\left(f\\left(y_i;\\widehat{\\theta}\\right)\\right)
  $$
  We are using the data twice, once for computing the MLE, once for the sum.
  We need to penalize to correct for bias. First order bias correction is
  $$
  \\ell\\left(\\widehat{\\theta};\\mathbf{y}\\right) - \\textrm{dim}(\\theta)
  $$
  where $d$ is the dimension of $\\theta$. The $\\textbf{AIC}$ is defined as
  $$
  AIC = - 2\\ell\\left(\\widehat{\\theta};\\mathbf{y}\\right) + 2\\textrm{dim}(\\theta)
  $$
  The model with the smallest AIC is the best. This implies a test when we have a point null in the interior of an alternative
  $$
  \\text{Reject }H_0\\text{ if }\\lambda(\\mathbf{y})>2d
  $$
  But we can also compare models that cannot described by a test!
  "
}


## Server function - inclusion of session as input is to allow for additional dynamic control of UIs (like slider bounds)
shinyServer(function(input, output, session) {
  y = eventReactive({input$model; input$n_samp; input$theta; input$gen_new},{
    obs_samp_fun(input$model,input$n_samp,input$theta)   
  },ignoreNULL = FALSE)
  stats = eventReactive({input$model; input$n_samp; input$theta; input$gen_new},{
    lambda_dist_fun(input$model,input$n_samp,input$theta)   
  },ignoreNULL = FALSE)
  dens_stat = eventReactive({input$model; input$n_samp; input$theta; input$gen_new},{
     chi_sq_dens_fun_samp(stats())
  },ignoreNULL = FALSE)
  mle = eventReactive({input$model; input$n_samp; input$theta; input$gen_new},{
    mle_fun(y(),input$model)   
  },ignoreNULL = FALSE)
  theta_0 = eventReactive(input$model,{
    theta_0_fun(input$model)
  })
  ll_null = eventReactive({input$model; input$n_samp; input$theta; input$gen_new},{
    loglikfun(theta_0(),input$model,y(),c(0,1/mean(y())))   
  },ignoreNULL = FALSE)
  ll_max = eventReactive({input$model; input$n_samp; input$theta; input$gen_new},{
    loglikfun(mle()[1],input$model,y(),mle())   
  },ignoreNULL = FALSE)
  theta_vals_plot = eventReactive({input$model; input$n_samp; input$theta; input$gen_new},{
    yy = y()
    if(input$model=="gaussian"){
      rr = range(c(theta_0(),c(-1,1)*sd(yy)/sqrt(input$n_samp)*4+mle()[1],2*mle()[1]-theta_0()))
      seq(rr[1],rr[2],length.out=1000)
    }else if(input$model=="bernoulli"){
      rr = range(c(theta_0(),c(-1,1)*sd(yy)/sqrt(input$n_samp)*4+mle()[1],2*mle()[1]-theta_0()))
      xx = seq(rr[1],rr[2],length.out=1000)
      xx[xx>0 & xx<1]
    }else if(input$model=="poisson"){
      rr = range(c(theta_0(),c(-1,1)*sd(yy)/sqrt(input$n_samp)*4+mle()[1],2*mle()[1]-theta_0()))
      xx = seq(rr[1],rr[2],length.out=1000)
      xx[xx>0]
    }else{
      a = mle()[1]
      b = mle()[2]
      prec = matrix(c(trigamma(a),-1/b,-1/b,a/b^2),2,2)
      v = solve(prec)                    
      s = sqrt(v[1,1])
      rr = range(c(theta_0(),c(-1,1)*sd(yy)/sqrt(input$n_samp)*4+mle()[1],2*mle()[1]-theta_0()))
      xx = seq(rr[1],rr[2],length.out=1000)
      xx[xx>0]
    }
  },ignoreNULL = FALSE)
  observeEvent(input$model,{
    if(input$model=="gaussian"){
      updateSliderInput(session,"theta",value=theta_0(),min=-2,max=2,step=0.1)
    }else if(input$model=="bernoulli"){
      updateSliderInput(session,"theta",value=theta_0(),min=0.025,max=.975,step=0.025)
    }else if(input$model=="poisson"){
      updateSliderInput(session,"theta",value=theta_0(),min=0.5,max=4.5,step=0.1)
    }else{
      updateSliderInput(session,"theta",value=theta_0(),min=0.1,max=3,step=0.1)
    }
  })
  observeEvent(input$null_true,{
    updateSliderInput(session,"theta",value=theta_0())
  })
  
  output$plots = renderPlot({
    par(bg='lightcyan')
    if(input$plot_type=="loglik"){
      xx = theta_vals_plot()
      yy = V_loglikfun(xx,model=input$model,y=y(),mle=mle())
      plot(yy~xx,type='l',lwd=3,main="Log-Likelihood Plot",ylab="Log-Likelihood",xlab=expression(theta))
      abline(ll_null(),0,col="red",lwd=3,lty=3)
      abline(ll_max(),0,col="blue",lwd=3,lty=2)
      legend("bottom",legend=c("LogLik Fun", "Max Value","Null Value"),col=c("black","blue","red"),lty=c(1,2,3),cex=1.5,bty="n")
    }else{
    
      if(input$theta==theta_0()){
       
        d = dens_stat()
        plot(y_chi_sq~x_chi_sq,ylim=c(0,4),type='l',lwd=3,main=expression(chi[1]^2 ~ "Density"),xlab="x",ylab="Density")  
        lines(d[,"y"]~d[,"x"],col="orange",lwd=3,lty=2)
      }else{
        d = dens_stat()
        xx = d[,"x"]
        yy = dchisq(xx,1)
        plot(yy~xx,type='l',lwd=3,ylim=c(0,max(d[,'y'])),main=expression(chi[1]^2 ~ "Density"),xlab="x",ylab="Density") 
        lines(d[,"y"]~d[,"x"],col="orange",lwd=3,lty=2) 
      }
      
      
      
    }
  })
  
  # mle_out = eventReactive({input$dataset; input$model},{
  #   mle_all_out[[input$dataset]][[input$model]]
  # })
  # loglik_out = eventReactive({input$dataset; input$model},{
  #   loglik_all_out[[input$dataset]][,c("mu",input$model)]
  # })
  # fitted_dens_out = eventReactive({input$dataset; input$model},{
  #   fitted_dens_all_out[[input$dataset]][,c("y",input$model)]
  # })
  # 
  # output$plots = renderPlot({
  #   par(bg="lightcyan")
  #   if(input$plot_type=="data"){
  #     plot(dens_y(),lwd=3,main="",xlab="",ylab="")
  #     title(main="KDE of Data",cex.main=2)
  #     title(ylab="Density",cex.lab=2,line=2.5)
  #     title(xlab="y",cex.lab=2)
  #   }else if(input$plot_type=="model"){
  #     xx = seq(-6,6,length.out = 1000)
  #     dens_fun = dens_fun_list[[input$model]]
  #     if(input$model%in%c("gaussian","laplace")){
  #       yy1 = dens_fun(xx,log=FALSE)
  #       yy2 = dens_fun(xx,sigma=2,log=FALSE)
  #       yy3 = dens_fun(xx,sigma=0.5,log=FALSE)
  #     }else{
  #       yy1 = dens_fun(xx,log=FALSE)
  #       yy2 = dens_fun(xx,alpha=2,log=FALSE)
  #       yy3 = dens_fun(xx,alpha=0.5,log=FALSE)
  #     }
  #     plot(yy1~xx,type="l",lwd=3,main="",xlab="",ylab="",ylim=range(c(yy1,yy2,yy3)))
  #     lines(yy2~xx,col="blue",lwd=3,lty=2)
  #     lines(yy3~xx,col="red",lwd=3,lty=2)
  #     title(main="Theory Model Density",cex.main=2)
  #     title(ylab="Density",cex.lab=2,line=2.5)
  #     title(xlab="y",cex.lab=2)
  #     if(input$model%in%c("gaussian","laplace")){
  #       legend("topleft",legend=expression(sigma ~ "=1",sigma ~ "=2",sigma ~ "=0.5"),
  #              col=c("black","blue","red"),lty=c(1:3),lwd=3,cex=2)
  #     }else{
  #       legend("topleft",legend=expression(alpha ~ "=1",alpha ~ "=2",alpha ~ "=0.5"),
  #              col=c("black","blue","red"),lty=c(1:3),lwd=3,cex=2)
  #     }
  #   }else if(input$plot_type=="loglik"){
  #     plot(loglik_out()[,2]~loglik_out()[,1],type="l",lwd=3,main="",xlab="",ylab="")
  #     title(main=expression("Log-Likelihood for" ~ mu),cex.main=2)
  #     title(ylab="Log-Likelihood",cex.lab=2,line=2.5)
  #     title(xlab=expression(mu),cex.lab=2)
  #   }else{
  #     ylim=range(c(dens_y()$y,fitted_dens_out()[,2]))
  #     plot(dens_y(),lwd=3,main="",xlab="",ylab="",ylim=ylim)
  #     title(main="KDE of Data vs Theory Model Density",cex.main=2)
  #     title(ylab="Density",cex.lab=2,line=2.5)
  #     title(xlab="y",cex.lab=2)
  #     lines(fitted_dens_out()[,2]~fitted_dens_out()[,1],col="blue",lty=2,lwd=3)
  #   }
  # })
  output$supp_1 = renderUI({withMathJax(supp_1)})
  output$supp_2 = renderUI({withMathJax(supp_2)})
  output$supp_3 = renderUI({withMathJax(supp_3)})
  output$info_1 = renderUI({withMathJax(info_1(input$model))})
  output$info_2 = renderUI({withMathJax(info_2(input$model))})
  output$info_3 = renderUI({withMathJax(info_3)})
})
