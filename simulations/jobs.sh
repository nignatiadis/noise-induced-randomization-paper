#!/bin/bash

#SBATCH --job-name=noiserdd
#SBATCH --array=1-24
#SBATCH --time=24:00:00
#SBATCH --partition=hns,normal,stat
#SBATCH --ntasks=1
#SBATCH --mem=4G

# load modules
ml load gmp
ml load mpfr
ml load R/4.0.2
ml load julia/1.6.2

# execute script
Rscript simulation.R $SLURM_ARRAY_TASK_ID