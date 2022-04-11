using CSV
using DataFrames
using Plots
using LaTeXStrings

pgfplotsx()


education = CSV.File("ecls_RD.csv") |> DataFrame

sort!(education, :z)
education.trteffect = education.Y1 .- education.Y0


default_blue =RGB(33/255, 142/255, 248/255)
binary_education_plot = plot(education.z, education.trteffect, seriestype=:scatter, markershape=:vline,
						     size=(1000,400),
							 markersize=4,
    			 			 markerstrokealpha = 0.5,
	                         markerstrokecolor = default_blue,
	                         thickness_scaling = 2.5,
	                         grid=false,
	                         label="  Individual treatment effects",
	                         xguide = L"$Z_i$         [Base Score]",
	                         yguide = L"Y_i(1) - Y_i(0)",
	                         background_color_legend = :transparent,
	                         foreground_color_legend = :transparent,
	                         yticks = [-1;0;1])

plot!(binary_education_plot, education.z, education.smooth_spline, linecolor=:lightgrey,
	thickness_scaling = 2.5, linewidth=2.5, label="Smoothing spline fit")

savefig(binary_education_plot, "ground_truth_binary.pdf")
