library(readstata13)

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