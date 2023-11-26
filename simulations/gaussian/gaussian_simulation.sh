#!/bin/bash

#SBATCH --job-name=noiserdd
#SBATCH --array=1-300
#SBATCH --time=12:00:00
#SBATCH --partition=general
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=20000

conda activate r_env

# execute script
Rscript gaussian_simulation.R $SLURM_ARRAY_TASK_ID
