#!/bin/bash

#SBATCH --job-name=noiserdd
#SBATCH --array=1-60
#SBATCH --time=13:00:00
#SBATCH --partition=general
#SBATCH --ntasks=1
#SBATCH --mem=4G

conda activate r_env

# execute script
Rscript gaussian_simulation.R $SLURM_ARRAY_TASK_ID