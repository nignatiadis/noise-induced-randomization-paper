library(readstata13)
library(REBayes)

setwd("~/Desktop/stanford/Autumn 2019/Stefan/code")
# get data 
data = read.dta13("data/ECLS_data.dta")
##cleaning up NA's 
get_data = function(base_score, base_std, year1_score, year2_score) {
  idx = !is.na(year1_score) & !is.na(year2_score) & !is.na(base_std) & base_std > 0 & !is.na(base_score) &
    (base_score >= -8) & (base_score <= 8) & 
    (year1_score >= -8) & (year1_score <= 8) & 
    (year2_score >= -8) & (year2_score <= 8)
  result = data.frame(base_score = base_score[idx],
                      base_std = base_std[idx],
                      year1_score = as.numeric(year1_score[idx] > 0.5), #dichotomization at 0.5
                      year2_score = as.numeric(year2_score[idx] > 0.5))
  return(result)
}

# get data we actually see
get_outcome = function(d, cutoff) {
  idx = (d$base_score > cutoff)
  Y = numeric(length(d$base_score))
  Y[idx] = d$year2_score[idx]
  Y[!idx] = d$year1_score[!idx]
  std = d$base_std
  result = data.frame(z = d$base_score,
                      Y = Y, std = std)
  return(result)
}


true_d = get_data(data$X2MTHETK5, data$X2MSETHK5, data$X4MTHETK5, data$X6MTHETK5)
c = -0.2
d = get_outcome(true_d, c)
z = d$z
std = d$std
Y = d$Y
data = data.frame(z= z, Y = Y, std = std)


# getting ground truth 
# the ground truth for E[Y(1) - Y(0)|Z]
get_true_tau = function(u) {
  fit = smooth.spline(true_d$base_score, true_d$year2_score - true_d$year1_score)
  return(predict(fit, u)$y)
}

c = -0.2
d = get_outcome(true_d, c)
z = d$z
Y = d$Y
std = d$std
variance = min(std)^2
my_seq = seq(from = -0.2, to = 0.2, by = 0.02)

## getting rd parameter
rd_ruth = sapply(c+my_seq, get_true_tau)

## getting policy parmeter for C' where C' varies 
my_seq = my_seq[my_seq != 0]
true_seq = numeric(length(my_seq))
est = GLmix(z, hist = TRUE, sigma = sqrt(variance))
# given the observed z, return an estimated density at a vector of values
z_dens = function(est, vec) {
  mat = as.matrix(sapply(vec, dnorm, mean = est$x, sd = est$sigma))
  result = est$y%*%mat
  return(result)
}

for (i in 1:length(my_seq)){
  if (my_seq[i] >= 0) {
    true_seq[i] = integrate(function(z) get_true_tau(z)*z_dens(est, z), c, c+my_seq[i])$value/integrate(function(z) z_dens(est, z), c, c+my_seq[i])$value
  }
  else{
    true_seq[i] = integrate(function(z) get_true_tau(z)*z_dens(est, z), c+my_seq[i], c)$value/integrate(function(z) z_dens(est, z), c+my_seq[i], c)$value
  }
}

policy_truth = data.frame(c_prime = c + my_seq, policy_par = true_seq)
