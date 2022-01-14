#!/bin/bash
#SBATCH -D /home/wang9418/Cbeticola/second_sample
#SBATCH --partition=med
#SBATCH --job-name=fang_second_sample
#SBATCH --nodes=1
#SBATCH --ntasks=12
#SBATCH --mem=1G
#SBATCH --time=10:00:00
#SBATCH --output=outfile.out
#SBATCH --error=outfile.err

source ~/.bashrc
conda activate rotate2

fastq-dump SRR12966174
REF1=~/refs/Cbeticola/GCA_002742065.1_CB0940_V2_genomic.fna
REF2=~/refs/Cbeticola/GCA_002742065.1_CB0940_V2_genomic.gff
R1=SRR12966237.fastq

fastqc $R1
fastp -i $R1 -o SRR12966174_QC.fastq

R2=SRR12966174_QC.fastq

fastqc $R2

bwa mem $REF1 $R2 > output.sam
samtools sort output.sam > output.bam
samtools index output.bam

mosdepth --by 1000 output output.bam
zcat output.regions.bed.gz > output.txt

Rscript script.R $ACC"_output.txt"

Rscript -e 'output <- read.table("output.txt", header=F); 
output_highcover <- output[output[,4] > (2*mean(output[,4])), ]; 
writeLines(paste("mean", mean(output[,4]), "median", median(output[,4]), sep=" "), "output_mean_med.txt"); 
write.table(output_highcover, "output_highcover.txt", sep="\t", row.names=F, col.names=F, quote=F)'
cat output_highcover.txt > output_highcover.bed



bedtools intersect -a $REF2 -b output_highcover.bed | awk '$3=="gene"' > output_intsct.bed
bedtools coverage -a $REF2 -b output_highcover.bed | awk '$3=="gene"' > output_cover.bed
cat output_cover.bed | awk '$13>0.5' > output_filtcover.bed
cat output_intsct.bed > output_intsct.txt
cat output_cover.bed > output_cover.txt
cat output_filtcover.bed > output_filtcover.txt




# sbatch script.sh