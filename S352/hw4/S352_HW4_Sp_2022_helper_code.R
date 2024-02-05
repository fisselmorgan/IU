## old version of functions
## these were from a previous semester
## i did not really like what was being called a rate and what was being called a shape

dinvgamma = function(x, shape, rate, scale=1/rate, log = FALSE) {
  #rate is beta
  #shape is alpha
  #scale is 1/beta
  y=1/x
  out = dgamma(y,shape,scale=scale,log=TRUE)-2*log(x)
  if(log){out}else{exp(out)}
}
dinvweibull = function(x, shape, scale = 1, log = FALSE) {
  #shape is k
  #scale is lambda
  y=1/x
  out = dweibull(y,shape,scale,log=TRUE)-2*log(x)
  if(log){out}else{exp(out)}
}
#############################


## new version of functions
## these are what are actually in the pdf for the hw 4 file
dinvgamma = function(x, shape, scale, log = FALSE) {
  #scale is beta
  #shape is alpha
  y=1/x
  out = dgamma(y,shape,rate=scale,log=TRUE)-2*log(x)
  if(log){out}else{exp(out)}
}
dinvweibull = function(x, shape, rate = 1, log = FALSE) {
  #shape is k
  #rate is lambda
  y=1/x
  out = dweibull(y,shape,scale=rate,log=TRUE)-2*log(x)
  if(log){out}else{exp(out)}
}
