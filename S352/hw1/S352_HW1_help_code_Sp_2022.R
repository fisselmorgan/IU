set.seed(1234567890) #setting the seed so we all get the same random data
y = rgamma(n=100,shape=10,rate=4) #just making some random data

#computing the answer by hand because we can
y_bar = mean(y)
s_squared_y = mean((y-y_bar)^2)
alpha_est_by_hand = y_bar^2/s_squared_y

#writing a function that is 0 at the estimated value
#the second argument is x (NOT y) - it is just a name
h = function(alpha,x){ 
  #some checking of the inputs
  if(alpha<=0){return(NA)} #returning NA instead of an error message
  if(class(x)!="numeric"){return("Argument x is not numeric.")}
  if(length(x)==1){return("Argment x is a scalar and needs to be a vector.")}
  if(length(unique(x))==1){return("Argument x needs at least two distinct values.")}
  
  #doing some computations of statistics
  x_bar = mean(x)
  s_squared_x = mean((x-x_bar)^2)
  
  #returning the equation that is 0 at the estimated value
  return(alpha - x_bar^2/s_squared_x)
}

#uniroot does one-dimensional root finding
#the arguments are the function f (here we are setting f=h),
#the interval (here we are setting it to be c(0.01,100),
#it might not contain the answer we are looking for), 
#the additional arguments to h after the first 
#are passed next in the ... (here we are passing the vector y to the named argument x),
#the final argument (extendInt="yes") is telling it to extend the interval 
#and keep searching if our guess of an interval does not contain the solution.
#extending the interval blindly can be dangerous if there are 
#restrictions on the first argument to the function.
#this is why we used NA in our input checking. 
#There are other things we can do to deal with this kind of issue. 
root_output = uniroot(f=h,interval=c(0.01,100),x=y,extendInt = "yes") 
print(root_output) #looking at output from uniroot
alpha_est_uniroot = root_output$root #extracting the root
print(c(alpha_est_by_hand,alpha_est_uniroot)) #comparing root to mean of x

#Seeing this use of uniroot work, I am going to wrap this all 
#in a function that will just take in the data and estimate alpha.
#Here we are going to take advantage of scoping
#I am making it take a vector of indices as a second argument 
#so it can be used with boot
shape_estimator_fun_using_mean_and_variance = function(x,ind){
  #some checking of the inputs
  if(class(x)!="numeric"){return("Argument x is not numeric.")}
  if(length(x)==1){return("Argment x is a scalar and needs to be a vector.")}
  if(length(unique(x))==1){return("Argument x needs at least two distinct values.")}
  if(missing(ind)){ind = c(1:length(x))} #getting ind if I forgot it
  
  x = x[ind] #subsetting data
  
  #doing some computations of statistics
  x_bar = mean(x)
  s_squared_x = mean((x-x_bar)^2)
  
  h = function(alpha){
    #the data x is not an argument, nor are the computed statistics.
    #when those objects are called here, 
    #the function h looks for them in its local environment.
    #they are not there, 
    #so it looks to the parent environment to find them.
    
    #catching negative alpha and returning NA
    if(alpha<=0){return(NA)}
    #returning the equation that is 0 at the estimated value
    return(alpha - x_bar^2/s_squared_x)
  }
  
  #getting uniroot solution
  #no need to pass the data here because we took advantage of scoping!
  root_output = uniroot(f=h,interval=c(.01,100),extendInt = "yes") 
  
  #returning the root
  return(root_output$root)
}

#just checking to see if it works
alpha_est_wrapped = shape_estimator_fun_using_mean_and_variance(y)
#printing all the estimates together to compare them
print(c(alpha_est_by_hand,alpha_est_uniroot,alpha_est_wrapped))
