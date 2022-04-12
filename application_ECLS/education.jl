using CSV
using DataFrames
using RegressionDiscontinuity
using MosekTools
using Empirikos
using StatsBase
using MosekTools
using Setfield
using LaTeXStrings
using RData
using JLD2

education_df = CSV.File("ecls_RD.csv") |> DataFrame
ν = minimum(education_df.std)

Zs = NormalSample.(education_df.z, ν)
Ys = education_df.Y
Zs_rd = RunningVariable(Zs, -0.2, :≧)

# Run analysis for RDD target at varying cutoffs

modified_cutoff_range = -0.3:0.02:-0.1

nir_fits_10 = Array{Any}(undef, length(modified_cutoff_range))
nir_fits_06 = Array{Any}(undef, length(modified_cutoff_range))


for (i, cprime) in enumerate(modified_cutoff_range)
    sharp_target = RegressionDiscontinuity.SharpRegressionDiscontinuityTarget(;
        cutoff = NormalSample(cprime, ν),
    )
    nir_sharp_target = NoiseInducedRandomization(;
        solver = Mosek.Optimizer,
        target = sharp_target,
        τ_range = 1.0,
    )
    nir_sharp_fit = fit(nir_sharp_target, Zs_rd, Ys)
    nir_refit = RegressionDiscontinuity.nir_sensitivity(nir_sharp_fit, Zs_rd, Ys, 0.6)
    nir_fits_10[i] = nir_sharp_fit
    nir_fits_06[i] = nir_refit
end

#jldsave("nir_fits_april11.jld2"; nir_fits_10, nir_fits_06)


cis_10 = getfield.(nir_fits_10, :confint)
cis_06 = getfield.(nir_fits_06, :confint)

using Plots
pgfplotsx()

theme(
    :default;
    background_color_legend = :transparent,
    foreground_color_legend = :transparent,
    grid = nothing,
    legendfonthalign = :left,
    size = (500, 400),
    thickness_scaling = 1.7,
)


rdd_target = CSV.File("rdd_target_pseudo_ground_truth.csv") |> DataFrame

plot(
    rdd_target.basescore,
    rdd_target.truth,
    seriescolor = "#550133",
    label = "Ground truth",
    linestyle = :dot,
)

plot!(
    modified_cutoff_range,
    getfield.(cis_10, :estimate),
    label = L"Estimate $\hat{\tau}_{\gamma}$",
    seriescolor = :"#018AC4",
)

plot!(
    modified_cutoff_range,
    cis_10,
    seriescolor = "#018AC4",
    fillalpha = 0.36,
    xlim = (-0.301, -0.1),
    ylim = (-0.05, 0.75),
    label = L"\textrm{NIR CI } (\mathcal{T}_{0.5})",
    xguide = L"$c'\;\;$     [intervention cutoff]",
    yguide = L"\tau_{c'} = E[Y_i(1) - Y_i(0) \mid Z_i = c']",
)

plot!(
    modified_cutoff_range,
    cis_06;
    show_ribbon = false,
    framestyle = :axes,
    legend = :bottomleft,
    label = L"\textrm{NIR CI } (\mathcal{T}_{0.3})",
)

savefig("rdd_target_education.tikz")




policy_target_intervals =
    [Interval.(-0.3:0.02:-0.22, -0.2); -0.2; Interval.(-0.2, -0.18:0.02:-0.1)]

nir_fits_policy_10 = Array{Any}(undef, length(modified_cutoff_range))
nir_fits_policy_06 = Array{Any}(undef, length(modified_cutoff_range))


for (i, cprime) in enumerate(policy_target_intervals)
    sharp_target = RegressionDiscontinuity.SharpRegressionDiscontinuityTarget(;
        cutoff = NormalSample(cprime, ν),
    )
    nir_sharp_target = NoiseInducedRandomization(;
        solver = Mosek.Optimizer,
        target = sharp_target,
        τ_range = 1.0,
    )
    nir_sharp_fit = fit(nir_sharp_target, Zs_rd, Ys)
    nir_refit = RegressionDiscontinuity.nir_sensitivity(nir_sharp_fit, Zs_rd, Ys, 0.6)
    nir_fits_policy_10[i] = nir_sharp_fit
    nir_fits_policy_06[i] = nir_refit
end


#jldsave("nir_fits_policy_april11.jld2"; nir_fits_policy_10, nir_fits_policy_06)


cis_policy_10 = getfield.(nir_fits_policy_10, :confint)
cis_policy_06 = getfield.(nir_fits_policy_06, :confint)

# load pseudo-ground truth
policy_target = CSV.File("policy_target_pseudo_ground_truth.csv") |> DataFrame

plot(
    policy_target.c_prime,
    policy_target.policy_par,
    seriescolor = "#550133",
    label = "Ground truth",
    linestyle = :dot,
)

plot!(
    modified_cutoff_range,
    getfield.(cis_policy_10, :estimate),
    label = L"Estimate $\hat{\tau}_{\gamma}$",
    seriescolor = :"#018AC4",
)

plot!(
    modified_cutoff_range,
    cis_policy_10,
    seriescolor = "#018AC4",
    fillalpha = 0.36,
    xlim = (-0.301, -0.1),
    ylim = (-0.05, 0.75),
    label = L"\textrm{NIR CI } (\mathcal{T}_{0.5})",
    xguide = L"$c'\;\;$     [intervention cutoff]",
    yguide = L"\tau_\pi = E[Y_i(1) - Y_i(0) \mid c' \leq Z_i < c]",
)

plot!(
    modified_cutoff_range,
    cis_policy_06;
    show_ribbon = false,
    framestyle = :axes,
    legend = :bottomleft,
    label = L"\textrm{NIR CI } (\mathcal{T}_{0.3})",
)

savefig("policy_target_education.tikz")
