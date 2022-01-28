# noise-induced-randomization-paper

A repository for reproducing the numerical results in the following preprint:

  >Eckles, Dean, Nikolaos Ignatiadis, Stefan Wager, and Han Wu. "Noise-induced randomization in regression discontinuity designs." arXiv preprint arXiv:2004.09458 (2022).

See [RegressionDiscontinuity.jl](https://github.com/nignatiadis/RegressionDiscontinuity.jl) for the Julia package implementing the proposed method.




# Software used

* [R](https://www.r-project.org/) version 4.0.2.
* The [Mosek](https://www.mosek.com/) convex programming solver, version 9.2, was used. Mosek requires a license (there is an option for a free academic license).
* [Julia](https://julialang.org/) version 1.6.2.
* All required Julia packages and their versions (for each analysis) are specified in the `Project.toml` and `Manifest.toml` files (within the sub-folders). They may be installed automatically by starting a Julia session in the corresponding sub-folder and typing:
```julia
using Pkg
Pkg.activate(".")
Pkg.instantiate()
```

There are three folders in this repository.

* `simulations`: Replication of simulation study
* `application_ART`: Replication of application: Retention of HIV patients
* `application_ECLS`: Replication of application: Test scores in early childhood

Instructions for reproducing each of the three above analyses are found in the per-sub-folder `README.md`.




