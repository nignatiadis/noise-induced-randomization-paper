# Replication of application: Retention of HIV patients

## Main analysis

The main dataset for this analysis is from the following work:

  >Bor, Jacob, Matthew P. Fox, Sydney Rosen, Atheendar Venkataramani, Frank Tanser, Deenan Pillay, and Till Bärnighausen. "Treatment eligibility and retention in clinical HIV care: A regression discontinuity study in South Africa." PLoS medicine 14, no. 11 (2017): e1002463.

The dataset can be downloaded (after registration and agreeing to the license) from the [InDepth data repository](https://www.indepth-ishare.org/index.php/catalog/140/study-description). Upon downloading the file `S1_Data.zip`, please extract the file `S1_Data.csv` into this folder to be able to run the following scripts:

* `art_nir.jl`: This (Julia) script runs the main analysis in Julia (first line of Table 1 and Figure 3). It also computes the worst-case curvature reported in the second line of Table 2. 
* `art_other_methods.R`: This (R) script constructs confidence intervals for the other methods shown in Table 1.
  * [optrdd](https://github.com/swager/optrdd) with worst-case curvature (as computed in `art_nir.jl`)
  * [optrdd](https://github.com/swager/optrdd) with curvature based on a heuristic implemented in the [RDHonest](https://github.com/kolesarm/RDHonest) package.
  * [rdrobust](https://rdpackages.github.io/rdrobust/)



## Noise model 

To estimate the model for the noise in the CD4 counts, we use the replicate measurements reported in the following publication:

  >Daniel Francois Venter, Willem, Matthew F. Chersich, Mohammed Majam, Godspower Akpomiemie, Natasha Arulappan, Michelle Moorhouse, Nonkululeko Mashabane, and Deborah K. Glencross. "CD4 cell count variability with repeat testing in South Africa: Should reporting include both absolute counts and ranges of plausible values?." International journal of STD & AIDS 29, no. 11 (2018): 1048-1056.

Instructions for accessing the dataset are specified in the above paper.

We provide the code for estimating the noise level as ν=0.19 and reproducing Figure 2 of the manuscript in the file: 
* `cd4_noise.jl`