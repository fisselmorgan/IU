# Exam 2 
# Problems review in class
# Question 6
#X1, X2, ..., X92 ~ P with EXi = 420, VarXi = 23 SDXi = sqrt(23)
# EXbar? = 420
# SD Xbar = sqrt(Var Xbar) = sqrt(23/92) = 0.5
# P(Xbar > 421) = 1 - P(Xbar <= 421)
1 - pnorm(421, 420, sqrt(23/92))
# 0.023

# Xbar: lions
# Ybar: tigers
# P(Xbar > Ybar) = P(Xbar - Ybar > 0) = 1 = P(Xbar - Ybar <= 0)
# E(Xbar - Ybar) = EXbar - EYbar = 418 - 420 = -2
# Var(Xbar - Ybar) = VarXbar + VarYbar = 16/72 + 23/92
1 - pnorm(0, -2, sqrt(16/72 + 23/92))
