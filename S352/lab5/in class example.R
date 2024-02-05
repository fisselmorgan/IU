# example likelihoof ratio test
# one parameter full model (alternative) and specific parameter
# value for the null model 
# simplest is y1,...,yn iid bernouli p
# H0: p=p0
# HA: p!=p0


mle_bernoulli = function(y){
  # MLE for alternative hypothesis
  p_hat = mean(y)
  loglik = sum(dbinom(y,1,p_hat,log=TRUE))
  d=1 # dimension parameter
  AIC= -2*loglik + 2*d
  return(list(theta=p_hat,loglik=loglik,dim=d,AIC=AIC))
}

mle_bernoulli_null = function(y,p_0){
  # MLE for alternative hypothesis
  loglik = sum(dbinom(y,1,prob=p_0,log=TRUE))
  d=0 # dimension parameter
  AIC= -2*loglik + 2*d
  return(list(theta=c(),loglik=loglik,dim=d,AIC=AIC))
}

# make some data for an example
y=rbinom(100,1,prob=0.6)
# make H0 for an example 
p_0 = 0.5 
# make a significance level for the test
significance_level = 0.1

# LRT computations
fit_alternative = mle_bernoulli(y)
fit_null = mle_bernoulli_null(y,p_0)
test_stat = 2*(fit_alternative$loglik - fit_null$loglik)
print(test_stat)
df = fit_alternative$dim - fit_null$dim
p_value = pchisq(test_stat,df=df ,lower.tail = FALSE)
print(p_value)
cutoff = qchisq(significance_level,df=df,lower.tail=FALSE)
print(cutoff)
if(test_stat>cutoff){
  decision = 'Reject H0'
}else{
  decision = 'Fail to reject H0'
}

# make a LRT function 
LRT_bernoulli_fun = function(y,p_0,significance_level){
  mle_bernoulli = function(y){
    # MLE for alternative hypothesis
    p_hat = mean(y)
    loglik = sum(dbinom(y,1,p_hat,log=TRUE))
    d=1 # dimension parameter
    AIC= -2*loglik + 2*d
    return(list(theta=p_hat,loglik=loglik,dim=d,AIC=AIC))
  }
  
  mle_bernoulli_null = function(y,p_0){
    # MLE for alternative hypothesis
    loglik = sum(dbinom(y,1,prob=p_0,log=TRUE))
    d=0 # dimension parameter
    AIC= -2*loglik + 2*d
    return(list(theta=c(),loglik=loglik,dim=d,AIC=AIC))
  }
  
  # make some data for an example
  y=rbinom(100,1,prob=0.6)
  # make H0 for an example 
  p_0 = 0.5 
  # make a significance level for the test
  significance_level = 0.1
  
  # LRT computations
  fit_alternative = mle_bernoulli(y)
  fit_null = mle_bernoulli_null(y,p_0)
  test_stat = 2*(fit_alternative$loglik - fit_null$loglik)
  #print(test_stat)
  df = fit_alternative$dim - fit_null$dim
  p_value = pchisq(test_stat,df=df ,lower.tail = FALSE)
  #print(p_value)
  cutoff = qchisq(significance_level,df=df,lower.tail=FALSE)
  #print(cutoff)
  if(test_stat>cutoff){
    decision = 'Reject H0'
  }else{
    decision = 'Fail to reject H0'
  }
  AIC_null_minus_AIC_alternative = 
    fit_null$AIC - fitalternative$AIC #test_stat - 2*df
  return(list(y=y,
              p_0=p_0,
              significance_level = significance_level,
              fitalternative = fit_alternative, 
              fit_null = fit_null,
              test_stat = test_stat,
              df = df,
              p_value = p_value, 
              cutoff = cutoff,
              decision = decision,
              AIC_null_minus_AIC_alternative = AIC_null_minus_AIC_alternative))
}

LRT_bernoulli_fun(y, p_0, significance_level)

btest_out = binom.test(x = sum(y), n = length(y), p=p_0)
names(btest_out)

