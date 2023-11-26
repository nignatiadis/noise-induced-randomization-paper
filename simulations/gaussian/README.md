# Code for simulation study (Section 8.2.) with Continuous Running Variable and Misspecification
 

 * `gaussian_simulation.R`: Main file implementing the simulations in R. It calls upon the Noise-Induced Randomization implementation on the Julia package [RegressionDiscontinuity.jl](https://github.com/nignatiadis/RegressionDiscontinuity.jl) through the [JuliaCall](https://cran.r-project.org/web/packages/JuliaCall/index.html) package. It also calls upon the  [rdrobust](https://cran.r-project.org/web/packages/rdrobust/index.html) R package. Its execution is parallelized (we used SLURM as shown in `gaussian_simulation.sh`).
* `plotting.R`: This file takes as input the results of running `gaussian_simulation.R` and summarizes the results as a figure.