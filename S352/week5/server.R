####################################
## STAT S352
## Data Modeling and Inference
## Andrew Womack
####################################
## Shiny App 5
## Server File
## Fisher Information
####################################

library(shiny)

## Functions for separating content and computation from formatting

##################
# data processing step
##################

ran_gen = function(n,theta_star,model){
  if(model=='gaussian'){
    rnorm(n,theta_star,1)
  }else if(model=='bernoulli'){
    rbinom(n,1,theta_star)
  }else if(model=='poisson'){
    rpois(n,theta_star)
  }else{
    rexp(n,theta_star)
  }
}

loglik_fun = function(theta,y,model){
  if(model=='gaussian'){
    sum(dnorm(y,theta,1,log=TRUE))
  }else if(model=='bernoulli'){
    sum(dbinom(y,1,theta,log=TRUE))
  }else if(model=='poisson'){
    sum(dpois(y,theta,log=TRUE))
  }else if(model=='exponential'){
    sum(dexp(y,theta,log=TRUE))
  }
}
V_loglik_fun = Vectorize(loglik_fun,vectorize.args = "theta")

info_fun = function(y,model,theta_star){
  n = length(y)
  if(model=='gaussian'){
    theta_hat = mean(y)
    fi_hat = n
    fi_star = n
    lb = -Inf
    ub = Inf
    samp_dens = function(theta,n,theta_star){
      dnorm(theta,theta_star,1/sqrt(n))
    }
    approx_samp_dens = function(theta,theta_star,fi_hat){
      dnorm(theta,theta_star,1/sqrt(fi_hat))
    }
  }else if(model=='bernoulli'){
    theta_hat = mean(y)
    fi_hat = n/(theta_hat*(1-theta_hat))
    fi_star = n/(theta_star*(1-theta_star))
    lb = theta_star/1000
    ub = 1-theta_star/1000
    samp_dens = function(theta,n,theta_star){
      dbinom(round(n*theta),n,theta_star)*n
    }
    approx_samp_dens = function(theta,theta_star,fi_hat){
      dnorm(theta,theta_star,1/sqrt(fi_hat))
    }
  }else if(model=='poisson'){
    theta_hat = mean(y)
    fi_hat = n/theta_hat
    fi_star = n/theta_star
    lb = theta_star/1000
    ub = Inf
    samp_dens = function(theta,n,theta_star){
      dpois(round(n*theta),n*theta_star)*n
    }
    approx_samp_dens = function(theta,theta_star,fi_hat){
      dnorm(theta,theta_star,1/sqrt(fi_hat))
    }
  }else if(model=='exponential'){
    theta_hat = 1/mean(y)
    fi_hat = n/theta_hat^2
    fi_star = n/theta_star^2
    lb = theta_star/1000
    ub = Inf
    samp_dens = function(theta,n,theta_star){
      dgamma(1/theta,n,n*theta_star)*1/theta^2
    }
    approx_samp_dens = function(theta,theta_star,fi_hat){
      dnorm(theta,theta_star,1/sqrt(fi_hat))
    }
  }
  return(list(theta_hat=theta_hat,fi_hat=fi_hat,
              theta_star=theta_star,fi_star=fi_star,
              lb=lb,ub=ub,
              samp_dens=samp_dens,
              approx_samp_dens = approx_samp_dens))
}

plot_info_fun = function(y,model,theta_star,z_score=2){
  info = info_fun(y,model,theta_star)
  theta_hat = info$theta_hat
  fi_hat = info$fi_hat
  fi_star = info$fi_star
  lb = info$lb
  ub = info$ub
  me = z_score/sqrt(min(c(fi_hat,fi_star)))
  theta_lb = max(c(lb,min(c(theta_hat-me,theta_star-me))))
  theta_ub = min(c(ub,max(c(theta_hat+me,theta_star+me))))
  theta = seq(theta_lb,theta_ub,length.out=1000) 
  loglik_max = loglik_fun(theta_hat,y,model)
  approx_loglik_data = loglik_max - 0.5*fi_hat*(theta-theta_hat)^2
  loglik_star = loglik_fun(theta_star,y,model)
  approx_loglik_star = loglik_star - 0.5*fi_star*(theta-theta_star)^2
  loglik = V_loglik_fun(theta=theta,y=y,model=model)
  samp_dens = info$samp_dens(theta,length(y),theta_star)
  approx_samp_dens = info$approx_samp_dens(theta,theta_star,fi_hat)
  
  return(list(theta = theta, loglik = loglik,
              approx_loglik_data = approx_loglik_data,
              approx_loglik_star = approx_loglik_star,
              theta_hat = theta_hat, theta_star = theta_star,
              fi_hat = fi_hat, fi_star = fi_star,
              samp_dens=samp_dens,
              approx_samp_dens = approx_samp_dens))
}

info_1 = function(model){
  if(model=="gaussian"){
    "
    Model Assumption and Data Generation:
    $$
    y_1,\\ldots,y_n\\stackrel{iid}{\\sim}\\text{N}(\\mu,1)
    $$
    Density of a single datum:
    $$
    f(y) = \\frac{1}{\\sqrt{2\\pi}}\\exp\\left(-\\frac{1}{2}(y-\\mu)^2\\right)
    $$
    Log-Density of a single datum:
    $$
    \\log(f(y)) = -\\frac{1}{2}\\log(2\\pi) - \\frac{1}{2} (y-\\mu)^2
    $$
    Second Derivative of Log-Density of a single datum:
    $$
    \\frac{\\partial^2}{\\partial \\mu^2}\\log(f(y)) = -1
    $$
    "
  }else if(model=="bernoulli"){
    "
    Model Assumption and Data Generation:
    $$
    y_1,\\ldots,y_n\\stackrel{iid}{\\sim}\\text{Bernoulli}(p)
    $$
    Density of a single datum:
    $$
    f(y) = p^y(1-p)^{1-y}
    $$
    Log-Density of a single datum:
    $$
    \\log(f(y)) = y\\log(p)+(1-y)\\log(1-p)
    $$
    Second Derivative of Log-Density of a single datum:
    $$
    \\frac{\\partial^2}{\\partial p^2}\\log(f(y)) = -\\frac{y}{p^2}-\\frac{1-y}{(1-p)^2}
    $$
    "
  }else if(model=="poisson"){
    "
    Model Assumption and Data Generation:
    $$
    y_1,\\ldots,y_n\\stackrel{iid}{\\sim}\\text{Poisson}(\\lambda)
    $$
    Density of a single datum:
    $$
    f(y) = \\frac{\\lambda^y}{y!}\\exp(-\\lambda)
    $$
    Log-Density of a single datum:
    $$
    \\log(f(y)) = y\\log(\\lambda)-\\log(y!)-\\lambda
    $$
    Second Derivative of Log-Density of a single datum:
    $$
    \\frac{\\partial^2}{\\partial\\lambda^2}\\log(f(y)) = -\\frac{y}{\\lambda^2}
    $$
    "
  }else{
    "
    Model Assumption and Data Generation:
    $$
    y_1,\\ldots,y_n\\stackrel{iid}{\\sim}\\text{Exponential}(\\beta)
    $$
    Density of a single datum:
    $$
    f(y) = \\beta\\exp(-\\beta y)
    $$
    Log-Density of a single datum:
    $$
    \\log(f(y)) = \\log(\\beta)-\\beta y
    $$
    Second Derivative of Log-Density of a single datum:
    $$
    \\frac{\\partial^2}{\\partial\\beta^2}\\log(f(y)) = -\\frac{1}{\\beta^2}
    $$
    "
  }
}
info_2 = function(model){
  if(model=="gaussian"){
    "
    $$
    \\begin{array}{rcl}
    \\ell(\\mu)  &=& \\sum_{i=1}^n \\log(f(y_i))\\\\
    &=& \\sum_{i=1}^n\\left(-\\frac{1}{2}\\log(2\\pi) - \\frac{1}{2} (y_i-\\mu)^2\\right) \\\\
    &=& -\\frac{n}{2}\\log(2\\pi) - \\frac{1}{2}\\sum_{i=1}^n (y_i-\\mu)^2 \\\\
     &=& -\\frac{n}{2}\\log(2\\pi) \\\\&&- \\frac{1}{2}\\left(n\\mu^2-2\\mu\\sum_{i=1}^n y_i+\\sum_{i=1}^n y_i^2\\right)
     \\\\
     &=& -\\frac{n}{2}\\log(2\\pi)- \\frac{1}{2}\\sum_{i=1}^n y_i^2 \\\\&&- \\frac{n}{2}\\left(\\mu^2-2\\mu\\overline{y}\\right)
     \\\\
     \\widehat{\\mu}&=& \\overline{y}\\\\
    \\ell(\\mu) &=& -\\frac{n}{2}\\log(2\\pi)- \\frac{1}{2}\\sum_{i=1}^n (y_i-\\overline{y})^2 \\\\
    &&- 0.5\\,n\\left(\\mu-\\overline{y}\\right)^2
    \\end{array}
    $$
    "
  }else if(model=="bernoulli"){
    "
    $$
    \\begin{array}{rcl}
    \\ell(p) &=& \\sum_{i=1}^n \\log(f(y_i))\\\\
    &=& \\sum_{i=1}^n \\left(y_i\\log(p) + (1-y_i)\\log(1-p)\\right)\\\\
     &=& n\\left(\\overline{y}\\log(p)+(1-\\overline{y})\\log(1-p)\\right) 
     \\\\
     \\widehat{p}&=& \\overline{y}\\\\
    \\ell(p)
     &\\approx&
     n\\left(\\overline{y}\\log(\\overline{y})+(1-\\overline{y})\\log(1-\\overline{y})\\right)
     \\\\&&-0.5\\,\\frac{n}{\\overline{y}(1-\\overline{y})}(p-\\overline{y})^2
    \\end{array}
    $$
    "
  }else if(model=="poisson"){
    "
    $$
    \\begin{array}{rcl}
    \\ell(\\lambda)  &=& \\sum_{i=1}^n \\log(f(y_i))\\\\
    &=& \\sum_{i=1}^n \\left(y_i\\log(\\lambda) -\\log(y_i!)-\\lambda\\right)\\\\
     &=& -\\sum_{i=1}^n\\log(y_i!) + n\\left(\\overline{y}\\log(\\lambda)-\\lambda\\right) 
     \\\\
     \\widehat{\\lambda}&=& \\overline{y}\\\\
    \\ell(\\lambda)
     &\\approx& -\\sum_{i=1}^n\\log(y_i!) + n\\left(\\overline{y}\\log(\\overline{y})-\\overline{y}\\right)
     \\\\&&-0.5\\,\\frac{n}{\\overline{y}}(\\lambda-\\overline{y})^2
    \\end{array}
    $$
    "
  }else{
    "
    $$
    \\begin{array}{rcl}
    \\ell(\\beta)  &=& \\sum_{i=1}^n \\log(f(y_i))\\\\
    &=& \\sum_{i=1}^n \\left(\\log(\\beta) -\\beta y_i\\right) \\\\
     &=& n\\left(\\log(\\beta)-\\beta\\overline{y}\\right) 
     \\\\
     \\widehat{\\beta}&=& \\frac{1}{\\overline{y}}\\\\
    \\ell(\\beta)
     &\\approx& n\\left(-\\log(\\overline{y})-1\\right)
     \\\\ &&-0.5\\,n\\overline{y}^2\\left(\\beta-\\frac{1}{\\overline{y}}\\right)^2
    \\end{array}
    $$
    "
  }
}
info_3 = function(model){
  if(model=="gaussian"){
    "
    Expected ($n$ observations):
    $$
    \\begin{array}{rcl}
    I_n(\\mu) &=&-n\\,\\text{E}\\left[\\frac{\\partial^2}{\\partial\\mu^2} \\log(f(Y))\\right]
    \\\\&=&-n\\,\\text{E}\\left[-1\\right]
    \\\\&=&n
    \\end{array}
    $$
    Observed ($n$ observations):
    $$
    \\begin{array}{rcl}
    \\widehat{I}_n(\\mu) &=&-\\sum_{i=1}^n\\left[\\frac{\\partial^2}{\\partial\\mu^2} \\log(f(y_i))\\right]
    \\\\&=&-\\sum_{i=1}^n\\left[-1\\right]
    \\\\&=&n
    \\end{array}
    $$
    Observed at MLE ($n$ observations):
    $$
    \\widehat{I}_n(\\widehat{\\mu})
    =
    n
    $$
    "
  }else if(model=="bernoulli"){
    "
    Expected ($n$ observations):
    $$
    \\begin{array}{rcl}
    I_n(p) &=&-n\\,\\text{E}\\left[\\frac{\\partial^2}{\\partial p^2} \\log(f(Y))\\right]
    \\\\&=&-n\\,\\text{E}\\left[-\\frac{Y}{p^2}-\\frac{1-Y}{(1-p)^2}\\right]
    \\\\&=&n\\left[\\frac{1}{p}+\\frac{1}{1-p}\\right] = \\frac{n}{p(1-p)}
    \\end{array}
    $$
    Observed ($n$ observations):
    $$
    \\begin{array}{rcl}
    \\widehat{I}_n(p) &=&-\\sum_{i=1}^n\\left[\\frac{\\partial^2}{\\partial p^2} \\log(f(y_i))\\right]
    \\\\&=&-\\sum_{i=1}^n\\left[-\\frac{y_i}{p^2}-\\frac{1-y_i}{(1-p)^2}\\right]
    \\\\&=&n\\left[\\frac{\\overline{y}}{p^2}+\\frac{1-\\overline{y}}{(1-p)^2}\\right]
    \\end{array}
    $$
    Observed at MLE ($n$ observations):
    $$
    \\widehat{I}_n(\\widehat{p})
    =
    n\\left[\\frac{\\overline{y}}{\\overline{y}^2}+\\frac{1-\\overline{y}}{(1-\\overline{y})^2}\\right]
    =\\frac{n}{\\overline{y}(1-\\overline{y})}
    $$
    "
  }else if(model=="poisson"){
    "
    Expected ($n$ observations):
    $$
    \\begin{array}{rcl}
    I_n(\\lambda) &=&-n\\,\\text{E}\\left[\\frac{\\partial^2}{\\partial \\lambda^2} \\log(f(Y))\\right]
    \\\\&=&-n\\,\\text{E}\\left[-\\frac{Y}{\\lambda^2}\\right]
    \\\\&=&n\\left[\\frac{1}{\\lambda}\\right] = \\frac{n}{\\lambda}
    \\end{array}
    $$
    Observed ($n$ observations):
    $$
    \\begin{array}{rcl}
    \\widehat{I}_n(\\lambda) &=&-\\sum_{i=1}^n\\left[\\frac{\\partial^2}{\\partial\\lambda^2} \\log(f(y_i))\\right]
    \\\\&=&-\\sum_{i=1}^n\\left[-\\frac{y_i}{\\lambda^2}\\right]
    \\\\&=&n\\left[\\frac{\\overline{y}}{\\lambda^2}\\right]
    \\end{array}
    $$
    Observed at MLE ($n$ observations):
    $$
    \\widehat{I}_n(\\widehat{\\lambda})
    =
    n\\left[\\frac{\\overline{y}}{\\overline{y}^2}\\right]
    =\\frac{n}{\\overline{y}}
    $$
    "
  }else{
    "
    Expected ($n$ observations):
    $$
    \\begin{array}{rcl}
    I_n(\\beta) &=&-n\\,\\text{E}\\left[\\frac{\\partial^2}{\\partial \\beta^2} \\log(f(Y))\\right]
    \\\\&=&-n\\,\\text{E}\\left[-\\frac{1}{\\beta^2}\\right]
    \\\\&=&\\frac{n}{\\beta^2}
    \\end{array}
    $$
    Observed ($n$ observations):
    $$
    \\begin{array}{rcl}
    \\widehat{I}_n(\\beta) &=&-\\sum_{i=1}^n\\left[\\frac{\\partial^2}{\\partial\\beta^2} \\log(f(y_i))\\right]
    \\\\&=&-\\sum_{i=1}^n\\left[-\\frac{1}{\\beta^2}\\right]
    \\\\&=&n\\left[\\frac{1}{\\beta^2}\\right]
    \\end{array}
    $$
    Observed at MLE ($n$ observations):
    $$
    \\widehat{I}_n(\\widehat{\\beta})
    =
    n\\left[\\frac{1}{\\left(\\frac{1}{\\overline{y}}\\right)^2}\\right]
    =n\\overline{y}^2
    $$
    "
  }
}

main_graph_1 = paste(c("Gaussian","Bernoulli","Poisson","Exponential"),"Log-Likelihood",sep=" ")
main_graph_2 = paste(c("Gaussian","Bernoulli","Poisson","Exponential"),"MLE Sampling Density",sep=" ")
names(main_graph_1) = names(main_graph_2) = c("gaussian","bernoulli","poisson","exponential")
x_lab_expr = c(expression(mu),expression(p),expression(lambda),expression(beta))
names(x_lab_expr) = names(main_graph_1)
z_score = 4
y_lab_2 = c("Density","Mass","Mass","Density")
names(y_lab_2) = names(x_lab_expr)

## Server function - inclusion of session as input is to allow for additional dynamic control of UIs (like slider bounds)
shinyServer(function(input, output, session) {
  observeEvent(input$model,{
    updateSliderInput(session,'n_samp',value=10)
  })
  theta = eventReactive({input$model; input$mu; input$p; input$lambda; input$beta},{
    if(input$model=='gaussian'){
      input$mu
    }else if(input$model=='bernoulli'){
      input$p
    }else if(input$model=='poisson'){
      input$lambda
    }else{
      input$beta
    }
  })
  y = eventReactive({theta(); input$n_samp; input$gen_new},{
    ran_gen(input$n_samp,theta(),input$model)
  },ignoreNULL=FALSE)
  
  info_plots = eventReactive(y(),{
    plot_info_fun(y(),input$model,theta(),z_score)
  })
  output$plot = renderPlot({
    par(bg="lightcyan")
    if(input$plot_type=="loglik"){
      plot(info_plots()[['loglik']]~info_plots()[['theta']],lwd=6,main="",xlab="",ylab="",type="l")
      lines(info_plots()[['approx_loglik_data']]~info_plots()[['theta']],lwd=3,col='orange',lty=2)
      #lines(info_plots()[['approx_loglik_star']]~info_plots()[['theta']],lwd=3,col='purple',lty=3)
      title(main=main_graph_1[input$model],cex.main=2)
      title(ylab="Log-Likelihood",cex.lab=2,line=2.5)
      title(xlab=x_lab_expr[input$model],cex.lab=2)
      legend("bottom",legend=c("Actual","Approx"),
             col=c("black","orange"),lty=c(1,2),lwd=c(6,3),
             bty="n",cex=2)
    }else{
      plot(info_plots()[['samp_dens']]~info_plots()[['theta']],lwd=6,main="",xlab="",ylab="",type="l",
           ylim=c(0,max(c(info_plots()[['samp_dens']],
                          info_plots()[['approx_samp_dens']]))))
      lines(info_plots()[['approx_samp_dens']]~info_plots()[['theta']],lwd=3,col='orange',lty=2)
      #lines(info_plots()[['approx_loglik_star']]~info_plots()[['theta']],lwd=3,col='purple',lty=3)
      title(main=main_graph_2[input$model],cex.main=2)
      title(ylab="Density",cex.lab=2,line=2.5)
      title(xlab=x_lab_expr[input$model],cex.lab=2)
      legend("topleft",legend=c("Actual","Approx"),
             col=c("black","orange"),lty=c(1,2),lwd=c(6,3),
             bty="n",cex=2)
    }
  })
  output$info_1 = renderUI({withMathJax(info_1(input$model))})
  output$info_2 = renderUI({withMathJax(info_2(input$model))})
  output$info_3 = renderUI({withMathJax(info_3(input$model))})
})
