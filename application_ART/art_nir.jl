using CSV
using DataFrames
using Empirikos
using RegressionDiscontinuity
using MosekTools
using StatsBase
using LaTeXStrings
using Plots

# Set up plots
pgfplotsx()
theme(
    :default;
    background_color_legend = :transparent,
    foreground_color_legend = :transparent,
    grid = nothing,
    legendfonthalign = :left,
    size = (400, 300),
    thickness_scaling = 1.7,
)


bor_df = CSV.File("S1_Data.csv") |> DataFrame
bor_df = filter(x -> !ismissing(x.visit_test_6_18) & (x.EarliestCD4Count > 0), bor_df)


# Normal noise model with standard deviation ν
ν = 0.19
cutoff = log(350.0)

Zs = NormalSample.(log.(Float64.(bor_df.EarliestCD4Count)), ν)
Ys = Float64.(bor_df.visit_test_6_18)

Zs_bor = RunningVariable(Zs, cutoff, :<)


# Fit Noise-Induced Randomization
nir = NoiseInducedRandomization(; solver = Mosek.Optimizer)
nir_fit = StatsBase.fit(nir, Zs_bor, Ys)
nir_fit
#RD analysis with Noise Induced Randomization (NIR)
#─────────────────────────────────────────────────────────────────────────────────────────
#                            τ̂         se   max bias   Lower 95%  Upper 95%  CI halfwidth
#─────────────────────────────────────────────────────────────────────────────────────────
#Weighted RD estimand  0.110702  0.0483015  0.0203067  0.00824104   0.213163      0.102461
#─────────────────────────────────────────────────────────────────────────────────────────

# Plot the resulting weights

# γ+, γ-
plot(
    minimum.(response.(collect(keys(nir_fit.γs.γ₊.dictionary)))),
    collect(nir_fit.γs.γ₊.dictionary),
    label = L"+\gamma_+(\cdot)",
    color = :purple,
)
plot!(
    minimum.(response.(collect(keys(nir_fit.γs.γ₋.dictionary)))),
    -collect(nir_fit.γs.γ₋.dictionary),
    label = L"-\gamma_-(\cdot)",
    xguide = L"z",
    yguide = L"\gamma(z)",
    legend = :topleft,
    color = :darkgreen,
)
savefig("gamma_weights_cd4.tikz")

# h+, h-
_min, _max = extrema(response.(Zs))
_grid = _min:0.01:_max
plot(_grid, u -> nir_fit.γs.h₊(u), label = L"h(\cdot,\, \gamma_+)")
plot!(
    _grid,
    u -> nir_fit.γs.h₋(u),
    color = :black,
    label = L"h(\cdot,\, \gamma_-)",
    xguide = L"u",
    yguide = L"h(u)",
    legend = :topleft,
    linestyle = :dot,
)

savefig("h_weights_cd4.tikz")



# Compute worst-case curvature for use with OptRDD (this step can be time consuming)

## Start by computing marginal density at the cutoff
npmle_fit = fit(NPMLE(; solver = Mosek.Optimizer, convexclass = DiscretePriorClass()), Zs)
fhat = pdf(npmle_fit, NormalSample(cutoff, ν))
# 0.575567289811297


## Use above to compute curvature subject to density being at least as large as fhat.
curvature_type = RegressionDiscontinuity.NoiseInducedRandomizationCurvature(;
    density_lower_bound = fhat,
    ebayes_sample = NormalSample(0.0, ν),
    solver = Mosek.Optimizer,
    convexclass = DiscretePriorClass(-3.5:0.01:3.5),
    n_grid_f_prime = 400,
    width_grid_f_double_prime = 0.01,
)

worst_curv = fit(curvature_type)
worst_curv.max_curvature
# 31.08600469840819
