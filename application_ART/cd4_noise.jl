using Pkg
Pkg.activate(".")

using DataFrames
using Distributions
using LaTeXStrings
using Random
using StatsPlots
using StatFiles
using Statistics
using StatsBase



# Load data
venter_df = DataFrame(load("Venter_CD4.dta"))
size(venter_df,1) #771

# Preprocessing/ parse CD4 count to Integer and drop rows with missing entries
tryparsem(T, str) = something(tryparse(T, str), missing)
venter_df.Screening_CD4 = tryparsem.(Int, venter_df.Screening_CD4)
venter_df.Referral_CD4 = tryparsem.(Int, venter_df.Referral_CD4)
venter_df.Baseline_CD4 = tryparsem.(Int, venter_df.Baseline_CD4)
missing_venter = mapcols(x-> sum(ismissing.(x)), select(venter_df, [:Screening_CD4, :Referral_CD4, :Baseline_CD4]))
dropmissing!(venter_df, [:Referral_CD4, :Screening_CD4, :Baseline_CD4])
size(venter_df, 1)  #553

mapcols(x-> mean(x), select(venter_df, [:Screening_CD4, :Referral_CD4, :Baseline_CD4]))

#test 1: 199.3
#test 2: 206            Screening
#test 3: 197.6          Baseline?

describe(select(venter_df, [:Referral_CD4, :Screening_CD4, :Baseline_CD4]))


diffs = (log.(venter_df.Screening_CD4) .- log.(venter_df.Baseline_CD4))./sqrt(2)
avgs = (log.(venter_df.Screening_CD4) .+ log.(venter_df.Baseline_CD4))./sqrt(2)/2



Random.seed!(1)
normalizing_constant = mean([sqrt(mean(abs2,
                                     winsor(rand(Normal(), size(venter_df, 1) ); prop=0.05))) for i=1:1000])
σ = (mean(abs2, winsor(diffs; prop=0.05)) |> sqrt) / normalizing_constant


pgfplotsx()

binwidth = 0.05
diff_histogram_grid = -0.6:binwidth:0.6
diff_dense_grid = -0.6:0.001:0.6
replicate_plot = histogram(diffs, bins=diff_histogram_grid, normalize=true, ylim=(0,2.8),
						   size=(400,300),
                           label="", fillcolor=:lightgray, thickness_scaling = 1.7, linewidth=0.3,
		                   xlab=L"(Z_i - Z_i')/\sqrt{2}",
						   ylab="Density", grid=false )

savefig(replicate_plot, "venter_replicates.pdf")

plot!(replicate_plot, diff_dense_grid, pdf.(Normal(0.0, σ), diff_dense_grid), color=:darkorange,
				label=L"\mathcal{N}(0, 0.19^2)",
				legend=:topright,  bg_legend=:transparent, fg_legend=:transparent, linewidth=1.5)

savefig(replicate_plot, "venter_replicates.tikz")
