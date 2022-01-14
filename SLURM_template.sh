#!/bin/bash
#SBATCH -D /home/wang9418
#SBATCH --partition=med
#SBATCH --job-name=name
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=1G
#SBATCH --time=10:00:00
#SBATCH --output=outfile.out
#SBATCH --error=outfile.err

source ~/.bashrc

conda activate rotate2

echo KK

# sbatch name.sh