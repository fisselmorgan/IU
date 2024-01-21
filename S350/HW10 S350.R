#1 ISIR 13.4 Q2

#H0: The coloring is correct
#H1: The coloring is incorrect
ob = c(121,84,118,226,226,123)
prob = c(.13,.14,.13,.24,.20,.16)
sum_ob = sum(ob)
exp = sum_ob * prob
G2 = 2 * sum(ob*log(ob/exp))
1 - pchisq(G2, df=5)
# 1.141029e-05
P2 = sum((ob-exp)^2 / exp)
1 - pchisq(P2, df=5)
# 1.860203e-05
# The p-value is < .01 for both, 
# Therefore we reject the null H0
# accept the alternative H1

#2 ISIR 13.4 Q5
# a)
lead = c(1,2,3,4,5,6,7,8,9)
pmf = log10(1+1/lead)
sum(pmf) # = 1
# indeed this is a pmf
# b)
#H0: Leading digits follow Benford's Law
#H1: Leading digits don't follow Benford's Law
ob1 = c(107,55,39,22,13,18,13,23,15)
sum_ob1 = sum(ob1)
exp1 = sum_ob1 * pmf
G2 = 2 * sum(ob1*log(ob1/exp1))
1 - pchisq(G2, df=8)
# 0.04919622
P2 = sum((ob1-exp1)^2 / exp1)
1 - pchisq(P2, df=8)
# 0.06399094
# The p-value seems to be ~0.5(roughly)
# Therefore we accept the null H0

#3 ISIR 13.4 Q11

#H0: Does vary by histological type
#H1: Doesn't vary by histological type
n = 538
pos = c(74,68,154,18)
par = c(18,16,54,10)
non = c(12,12,58,44)
sumPos = sum(pos)
sumPar = sum(par)
sumNon = sum(non)
pPos = sumPos/n
pPar = sumPar/n
pNon = sumNon/n
expPos = pos * pPos
expPar = par * pPar
expNon = non * pNon
exp2 = c(expPos,expPar,expNon)
G2 = 2*sum(n*log(n/exp2))
1 - pchisq(G2, df=11)
# 0 
P2 = sum((n-exp2)^2/n)
1 - pchisq(P2, df=11)
# 0.1937669
# The second value doesn't help us much
# the first p-value is basically 0
# therefore we reject the null H0
# thus accepting the alternative H1

#4
#a)
observed = c(512,89,353,17,120,202,238,131,53,94,16,24)
n = 1749
depA = (512 + 89) / n
depB = (353 + 17) / n
depC = (120 + 202) / n
depD = (138 + 131) / n
depE = (53 + 94) / n
depF = (16 + 24) / n
men = (512 + 353 + 120 + 138 + 53 + 16) / n
women = (89 + 17 + 202 + 131 + 94 + 24) / n
expected = c(depA*men*n,depA*women*n,depB*men*n,depB*women*n,depC*men*n,depC*women*n,depD*men*n,depD*women*n,depE*men*n,depE*women*n,depF*men*n,depF*women*n)
# Department A: Men = 409.6009
#               Women = 191.3991
# DepartmentB: Men = 252.16695
#              Women = 117.83305
# DepartmentC: Men = 219.45340
#              Women = 102.54660
# DepartmentD: Men = 183.33219
#              Women = 85.66781
# DepartmentE: Men = 100.18525
#              Women = 46.81475
# DepartmentF: Men = 27.26129
#              Women = 12.73871
# Yes the sample size is large enough
#b) Here we can use both chi-squared tests
G2 = 2*sum(observed * log(observed/expected))
1 - pchisq(G2,df=6)
# 0 
P2 = sum((observed-expected)^2/expected)
1 - pchisq(P2,df=6)
# 0
# both tests result in 0
# therefore department and gender
# are not independent
#c) 
# Firstly, it should be said that it seems 
# gender may influence your department. 
# We reached this conclusion by finding a p-value
# for the chi-squared test 
# The p-value gives us a metric to determine 
# the relative validity of our null hypothesis
# if the value is 0 or VERY small then we have evidence to reject the null
# In this case we found that gender and department are
# not independent of each other (one or both variables are influenced by the other)
