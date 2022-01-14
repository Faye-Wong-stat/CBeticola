#!/bin/bash



# fastq-dump $1
# REF1=~/refs/Cbeticola/GCA_002742065.1_CB0940_V2_genomic.fna
# REF2=~/refs/Cbeticola/GCA_002742065.1_CB0940_V2_genomic.gff
# R1=${1}.fastq

# fastqc $R1
# fastp -i $R1 -o ${1}_QC.fastq

# R2=${1}_QC.fastq

# fastqc $R2

# bwa mem $REF1 $R2 > ${1}_output.sam
# samtools sort ${1}_output.sam > ${1}_output.bam
# samtools index ${1}_output.bam

# mosdepth --by 1000 output ${1}_output.bam
# zcat ${1}_output.regions.bed.gz > ${1}_output.txt

# Rscript --vanilla Cbeticola_average_cover.r $1

while read acc
do 
    echo $acc
done < runinfo.txt