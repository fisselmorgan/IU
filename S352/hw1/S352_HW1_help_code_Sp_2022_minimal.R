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

