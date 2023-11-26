# noise-induced-randomization-paper

A repository for reproducing the numerical results in the following preprint:

  >Eckles, Dean, Nikolaos Ignatiadis, Stefan Wager, and Han Wu. "Noise-induced randomization in regression discontinuity designs." arXiv preprint arXiv:2004.09458 (2022).

See [RegressionDiscontinuity.jl](https://github.com/nignatiadis/RegressionDiscontinuity.jl) for the Julia package implementing the proposed method.




# Software used

* [R](https://www.r-project.org/) 
* The [Mosek](https://www.mosek.com/) convex programming solverwas used. Mosek requires a license (there is an option for a free academic license).
* [Julia](https://julialang.org/) 


# Repository structure

There are three folders in this repository.

* `simulations`: Replication of simulation study
* `application_ART`: Replication of application: Retention of HIV patients
* `application_ECLS`: Replication of application: Test scores in early childhood

Instructions for reproducing each of the three above analyses are found in the per-sub-folder `README.md`.




