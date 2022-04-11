# Replication of Application: Test Scores in Early Childhood

# Main analysis files

* `ECLS_data.dta`: File with subset of ECLS data that we use in our analysis (see section below for instructions to generate this file).
* `education_data_processing.R`: R code that loads `ECLS_data.data`, creates the artificially constructed RDD and save its in the file `ecls_RD.csv`. It also computes the pseudo ground-truth for the two estimands we consider in our paper, and stores these in `rdd_target_pseudo_ground_truth.csv` and `policy_target_pseudo_ground_truth.csv`.
* `education_scatterplot.jl`: Julia code that generates the Scatterplot shown in Figure 4 of the manuscript. 
* `education.jl`: Julia code that runs the main analysis of the ECLS RDD and generates Figure 5.

# Getting the ECLS data

Here we describe how to generate the `ECLS_data.dta` file: 

* Download ChildK5p.zip from https://nces.ed.gov/ecls/dataproducts.asp and run the STATA scripts `ECLS_data.dct` and `ECLS_data.do` (available in this folder of the Github repository) to generate the data, resulting in the `ECLS_data.dta` file.

The `ECLS_data.dct` and `ECLS_data.do` scripts may be generated as follows:

* Go to https://nces.ed.gov/ecls/dataproducts.asp and download the Electronic Codebook software (requires Windows).
* Install the software, instructions can be found in chapter 8 of the [user manual](https://nces.ed.gov/pubsearch/pubsinfo.asp?pubid=2019051).
* Select the variables from the left panel and export to the right panel, we focus on math scores and their standard errors
* Click the "Extract with STATA" option. This will generate the `ECLS_data.dct` and `ECLS_data.do` files .
