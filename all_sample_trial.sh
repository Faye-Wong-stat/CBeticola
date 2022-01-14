#!/bin/bash
#SBATCH -D /home/wang9418/Cbeticola/all_samples
#SBATCH --partition=med
#SBATCH --job-name=fang_all_samples_trial
#SBATCH --nodes=1
#SBATCH --ntasks=12
#SBATCH --mem=1G
#SBATCH --time=10:00:00
#SBATCH --output=outfile.out
#SBATCH --error=outfile.err

source ~/.bashrc
conda activate rotate2

./function.sh SRR12966225

# Submitted batch job 40782259