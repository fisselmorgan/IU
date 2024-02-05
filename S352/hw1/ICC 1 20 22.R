library(boot) 

# example of wrapping the standard deviation function to use with boot
get_sd = function(y,index){
  return(sd(y[index]))
}

y = rnorm(10)
get_sd(y)

get_sd = function(y,index){
  if(missing(index)){
    index = c(1:length(y))
  }
  return(sd(y[index]))
}

get_sd(y)

get_sd = function(y,index=c(1:length(y))){
  return(sd(y[index]))
}

get_sd(y)

## use boot
boot_out = boot(y,get_sd,R=10000)
class(boot_out)
names(boot_out)
# get confidence interval 
boot.ci_out = boot.ci(boot_out,conf = 0.95,type=c("basic", "bca"))
boot.ci_out
class(boot.ci_out)
names(boot.ci_out)
boot.ci_out$basic
boot.ci_out$bca
