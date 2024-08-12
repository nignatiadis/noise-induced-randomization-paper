#!/bin/bash

#SBATCH --job-name=noiserdd
#SBATCH --array=1-300
#SBATCH --time=14:00:00
#SBATCH --partition=caslake
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=20000
#SBATCH --account=pi-ignat


ml load R/4.3.1
# execute script
Rscript gaussian_simulation.R $SLURM_ARRAY_TASK_ID

