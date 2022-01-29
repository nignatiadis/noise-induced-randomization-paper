library(rdrobust)
library(RDHonest)
library(optrdd)
library(readr)

d = readr::read_csv("S1_Data.csv")
z = d$EarliestCD4Count
Y_obs = d$visit_test_6_18
#exclude NA and zero CD4 count
idx = is.na(Y_obs) | z==0 
z = z[!idx]
Y_obs = Y_obs[!idx]

z_order = order(z)
z = log(z[z_order])
Y = Y_obs[z_order]


measurement_sd = 0.19
cutoff =  log(350)

## OptRDD fit with RDHonest heuristic
dt = data.frame(Y= Y, z = z)
rdhonest_dt = RDData(dt, cutoff)
bw_est_curv = NPR_MROT.fit(rdhonest_dt)
print(bw_est_curv)  ## 1.4597

out.1 = optrdd(z, Y, z >= cutoff, max.second.derivative = 1.46, alpha = 0.95)
print(out.1)

## OptRDD with worst-case curvature based on Gaussian assumption

# 31.1 is computed in the Julia file
out.2 = optrdd(z, Y, z >= cutoff, max.second.derivative = 31.1, alpha = 0.95)
print(out.2)



## RDRobust
rdrobust_fit = rdrobust(Y, z, cutoff)
est_rdrobust = rdrobust_fit$tau_bc[2] - rdrobust_fit$tau_bc[1]
ci_robust = (rdrobust_fit$ci[3,2] - rdrobust_fit$ci[3,1])/2
