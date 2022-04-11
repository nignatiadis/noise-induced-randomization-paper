library(readstata13)
library(REBayes)

# get data 
data <- read.dta13("ECLS_data.dta")

##cleaning up NA's 
get_data <- function(base_score, base_std, year1_score, year2_score) {
  idx <- !is.na(year1_score) & !is.na(year2_score) & !is.na(base_std) & base_std > 0 & !is.na(base_score) &
    (base_score >= -8) & (base_score <= 8) & 
    (year1_score >= -8) & (year1_score <= 8) & 
    (year2_score >= -8) & (year2_score <= 8)
  result <- data.frame(base_score = base_score[idx],
                      base_std = base_std[idx],
                      year1_score = as.numeric(year1_score[idx] > 0.5), #dichotomization at 0.5
                      year2_score = as.numeric(year2_score[idx] > 0.5))
  return(result)
}

# generate observed outcome
get_outcome <- function(d, cutoff) {
  idx = (d$base_score >= cutoff)
  Y = numeric(length(d$base_score))
  Y[idx] = d$year2_score[idx]
  Y[!idx] = d$year1_score[!idx]
  std = d$base_std
  result = data.frame(z = d$base_score,
                      Y = Y, 
                      std = std,
                      Y1 = d$year2_score, 
                      Y0 = d$year1_score)
  return(result)
}

# Construct artificial RDD 

true_d <- get_data(data$X2MTHETK5, data$X2MSETHK5, data$X4MTHETK5, data$X6MTHETK5)
c <- -0.2
d <- get_outcome(true_d, c)

# Save artificial RDD dataset

# Generate as below for RegressionDiscontinuity.jl package
# write.csv(d, "ecls_RD.csv", row.names=FALSE)
# We store it below here after using the smoothing spline to also impute E[Y(1)-Y(0)|Z]


# Compute "ground truth" for E[Y(1) - Y(0)|Z]
spline_fit <-  smooth.spline(true_d$base_score, true_d$year2_score - true_d$year1_score)

get_true_tau <- function(u) {
  return(predict(spline_fit, u)$y)
}

cs <- seq(from = -0.4, to = 0.0, by = 0.02)

rdd_target_pseudo_ground_truth <- sapply(cs, get_true_tau)

write.csv(data.frame(basescore=cs, truth=rdd_target_ground_truth), 
      "rdd_target_pseudo_ground_truth.csv", row.names=FALSE)

d$smooth_spline <- sapply(d$z, get_true_tau)
write.csv(d, "ecls_RD.csv", row.names=FALSE)

## Compute "ground truth" policy parameter for C' where C' varies 

my_seq <- seq(from = -0.2, to = 0.2, by = 0.02)
my_seq <- my_seq[my_seq != 0]
z <- d$z
Y <- d$Y
std <- d$std
variance <- min(std)^2


policy_param_pseudo_ground_truth <- numeric(length(my_seq))
est_glmix <- GLmix(z, hist = TRUE, sigma = sqrt(variance))

# given the observed z, return an estimated density at a vector of values
z_dens <- function(est, vec) {
  mat <- as.matrix(sapply(vec, dnorm, mean = est$x, sd = est$sigma))
  result <- est$y %*% mat
  return(result)
}

for (i in 1:length(my_seq)){
  if (my_seq[i] >= 0) {
    policy_param_pseudo_ground_truth[i] <- integrate(function(z) get_true_tau(z)*z_dens(est_glmix, z), c, c+my_seq[i])$value/integrate(function(z) z_dens(est_glmix, z), c, c+my_seq[i])$value
  }
  else{
    policy_param_pseudo_ground_truth[i] <- integrate(function(z) get_true_tau(z)*z_dens(est_glmix, z), c+my_seq[i], c)$value/integrate(function(z) z_dens(est_glmix, z), c+my_seq[i], c)$value
  }
}

policy_truth <- data.frame(c_prime = c + my_seq, policy_par = policy_param_pseudo_ground_truth)
write.csv(policy_truth,
      "policy_target_pseudo_ground_truth.csv", row.names=FALSE)
