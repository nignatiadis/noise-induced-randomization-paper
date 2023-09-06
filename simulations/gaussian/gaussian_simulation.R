args <- commandArgs(TRUE)
instance_number <- as.numeric(args[1])

n_parallel <- 20
parameter_mat <- expand.grid(n=c(1000,2000, 10000),
                             idx_parallel = 1:n_parallel)
                             
idx_parallel <- parameter_mat$idx_parallel[instance_number]
n <- parameter_mat$n[instance_number]
nreps <- 50 #100

library(rdrobust)
library(parallel)
library(JuliaCall)
library(tibble)

jl <- julia_setup()

RNGkind("L'Ecuyer-CMRG")
set.seed(2002) 
s <- .Random.seed
seed_list <- list()
for (i in seq_len(n_parallel)) {
  s <- nextRNGStream(s)
  seed_list[[i]] <- s
}
set.seed(seed_list[[idx_parallel]])


# jl$library("Pkg")
# jl$command('Pkg.activate(".")')
jl$library("Empirikos")
jl$library("RegressionDiscontinuity")
jl$library("MosekTools")

jl$command("function gaussian_nir(zs, Ys, cutoff, std)
              Zs = NormalSample.(zs, std)
              ZsR = RunningVariable(Zs, cutoff, :≧)
              nir = NoiseInducedRandomization(;solver=Mosek.Optimizer)
              nir_fit = fit(nir, ZsR, Ys)
              (estimate = nir_fit.confint.estimate,
               maxbias = nir_fit.confint.maxbias,
               se =  nir_fit.confint.se,
               upper = nir_fit.confint.upper,
               lower = nir_fit.confint.lower)
            end")



sds <- seq(0.1, by = 0.1, to = 0.9)
true_tau <- 0.0
c <- 0.0



res_tibble <- tibble(
  est = numeric(),
  halfci = numeric(),
  true_tau = numeric(),
  n = integer(),
  idx_parallel = integer(),
  rep = integer(),
  method = character(),
  sd = numeric()
)


for (i in seq_len(nreps)) {
  U <- rnorm(n, mean = 0.0, sd = 1.0)
  Y_obs <- rbinom(n, 1, prob = 0.25 * (U <= c) + 0.75 * (U > c))
  z <- rnorm(n, mean = U, sd = 0.5)
  w <- as.numeric(z >= c)

  rdrobust_fit <- try(rdrobust(Y_obs, z, c))

  if (!inherits(rdrobust_fit, "try-error")) {
    res_tibble <- add_row(res_tibble,
      est = rdrobust_fit$tau_bc[2] - rdrobust_fit$tau_bc[1],
      halfci = (rdrobust_fit$ci[3, 2] - rdrobust_fit$ci[3, 1]) / 2,
      true_tau = true_tau,
      n = n,
      idx_parallel = idx_parallel,
      rep = i,
      method = "rdrobust",
      sd = 0
    )
  }

  for (sd in sds) {
    nir_res <- try(jl$call("gaussian_nir", z, Y_obs, c, sd))
    if (!inherits(rdrobust_fit, "try-error")) {
      res_tibble <- add_row(res_tibble,
        est = nir_res$estimate,
        halfci = (nir_res$upper - nir_res$lower) / 2,
        true_tau = true_tau,
        n = n,
        idx_parallel = idx_parallel,
        rep = i,
        method = "NIR",
        sd = sd
      )
    }
  }
}


filename <- paste(toString(idx_parallel), toString(n), sep = "_")
filename <-  paste0("gaussian_", filename, ".Rds")
saveRDS(res_tibble, file.path("simulation_results", filename))


#bla <- res_tibble %>% mutate(lower = est - halfci, upper = est+halfci) %>% select(-n)