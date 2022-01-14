#!/bin/bash
#SBATCH -D /home/wang9418/Cbeticola/10_samples_more
#SBATCH --partition=med
#SBATCH --job-name=fang_10_samples_more
#SBATCH --nodes=1
#SBATCH --ntasks=12
#SBATCH --mem=1G
#SBATCH --time=24:00:00
#SBATCH --output=outfile.out
#SBATCH --error=outfile.err

source ~/.bashrc
conda activate rotate2

# write the loop here
# ./function.sh SRR12966174
while read acc
do 
    ./function.sh $acc
done < runinfo_10.txt

# Submitted batch job 40983040