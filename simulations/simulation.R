args <- commandArgs(TRUE)
instance_number <- as.numeric(args[1])

# Simulation parameters
parameter_mat <- expand.grid(c(1,2), c(2000, 10000), c(5, 10, 25, 50, 100, 200))
setup <- parameter_mat[instance_number,1]
sample_size <- parameter_mat[instance_number,2]
num_trial <- parameter_mat[instance_number,3]
B <- 1000 # Monte Carlo replicates


# Load packages
set.seed(1)
library(optrdd)
library(rdrobust)

# Julia setup
library(JuliaCall)

jl <- julia_setup()
jl$library("Pkg")
jl$command('Pkg.activate(".")')
jl$library("Empirikos")
JuliaCall::autowrap("Empirikos.BiasVarianceConfidenceInterval")
jl$library("RegressionDiscontinuity")
jl$library("MosekTools")

jl$command("function binomial_nir(zs, Ys, cutoff, ntrials)
              Zs = BinomialSample.(zs, Int(ntrials))
              ZsR = RunningVariable(Zs, Int(cutoff), :≧)
              nir = NoiseInducedRandomization(;solver=Mosek.Optimizer)
              nir_fit = fit(nir, ZsR, Ys)
              nir_fit.confint
            end")

jl$command("function binomial_worst_curvature(pmf, cutoff, ntrials)
              Z = BinomialSample(Int(cutoff), Int(ntrials))
              curvature_type = RegressionDiscontinuity.NoiseInducedRandomizationCurvature(;
                  density_lower_bound=pmf,
                  ebayes_sample=Z,
                  solver=Mosek.Optimizer,
                  convexclass =  DiscretePriorClass(0.001:0.001:0.999),
                  n_grid_f_prime = 500,
                  width_grid_f_double_prime = 0.005)
              fit(curvature_type).max_curvature
            end")


  

simulation_binom <- function(n, num_trial, setup) {
  
  tau_true <- 0
  result <- data.frame(matrix(NA, B, 13))
  
  names(result) <- c("est_optrdd_worstcase", "bias_optrdd_worstcase", "se_optrdd_worstcase", "len_optrdd_worstcase",
                     "est_rdrobust", "bias_rdrobust", "se_rdrobust", "len_rdrobust",
                     "est_nir", "bias_nir", "se_nir", "len_nir", 
                     "true_effect")

  c <- 0.6*num_trial
  pmf_at_c <- integrate(function(u) dbinom(c, num_trial, u), 0.5, 0.9)$value / 0.4
  worstcase_optrdd_bound <- jl$call("binomial_worst_curvature", pmf_at_c, c, num_trial)

  for (num_iter in seq_len(B)) {
    result[num_iter, "true_effect"] <- tau_true
    min_U <- 0.5
    max_U <- 0.9
    U <- sort(runif(n, min_U, max_U)) 
    z <- rbinom(n, size = num_trial, prob = U) 
    
    #potential outcomes 
    if (setup == 1) {
      Y0 <- rbinom(n, 1, prob = 0.25*(U <= 0.6) + 0.75*(U > 0.6))
      Y1 <- rbinom(n, 1, prob = 0.25*(U <= 0.6) + 0.75*(U > 0.6) + tau_true)
    } else {
      Y0 <- rbinom(n, 1, prob = sin(9*U)/3 + 0.4)
      Y1 <- rbinom(n, 1, prob = tau_true + sin(9*U)/3 + 0.4)
    }
    Y <- rbind(Y0, Y1)
    # assignment
    w <- as.numeric(z>=c)
    Y_obs <- sapply(1:n, function(i){ Y[w[i]+1,i]})

    # RDRobust
    rdrobust_fit <- try(rdrobust(Y_obs, z, c))
    if (!inherits(rdrobust_fit, "try-error")) {
      result[num_iter, "est_rdrobust"]  <- rdrobust_fit$tau_bc[2] - rdrobust_fit$tau_bc[1]
      result[num_iter, "bias_rdrobust"] <- abs(rdrobust_fit$bias[1]) + abs(rdrobust_fit$bias[2])
      result[num_iter, "se_rdrobust"]   <- rdrobust_fit$se[3]
      result[num_iter, "len_rdrobust"]  <- (rdrobust_fit$ci[3,2] - rdrobust_fit$ci[3,1])/2
    }

    # OPTRDD
    optrdd_worstcase <- optrdd(z, Y_obs, w, max.second.derivative = worstcase_optrdd_bound,
                      estimation.point = c, optimizer = "mosek")
    result[num_iter, "est_optrdd_worstcase"]  <- optrdd_worstcase$tau.hat
    result[num_iter, "bias_optrdd_worstcase"] <- optrdd_worstcase$max.bias
    result[num_iter, "se_optrdd_worstcase"]   <- optrdd_worstcase$sampling.se
    result[num_iter, "len_optrdd_worstcase"]  <- optrdd_worstcase$tau.plusminus

    # NIR 
    nir_res <- jl$call("binomial_nir", z, Y_obs, c, num_trial)
    result[num_iter, "est_nir"]  <- nir_res$estimate
    result[num_iter, "bias_nir"] <- nir_res$maxbias
    result[num_iter, "se_nir"]   <- nir_res$se
    result[num_iter, "len_nir"]  <- (nir_res$upper - nir_res$lower)/2
  }
  return(result)
}

if (!dir.exists("simulation_results")){
   dir.create("simulation_results")
}

result <- simulation_binom(sample_size, num_trial, setup)
filename <- paste(toString(setup), toString(sample_size), toString(num_trial), sep = "_")
filename <-  paste0(filename, ".Rds")
saveRDS(result, file.path("simulation_results",filename))

