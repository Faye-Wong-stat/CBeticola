#!/bin/bash

fastq-dump $1
REF1=~/refs/Cbeticola/GCA_002742065.1_CB0940_V2_genomic.fna
REF2=~/refs/Cbeticola/GCA_002742065.1_CB0940_V2_genomic.gff
R1=${1}.fastq

fastqc $R1
fastp -i $R1 -o ${1}_QC.fastq

R2=${1}_QC.fastq

fastqc $R2

bwa mem $REF1 $R2 > ${1}.sam
samtools sort ${1}.sam > ${1}.bam
samtools index ${1}.bam

mosdepth --by 1000 ${1} ${1}.bam
zcat ${1}.regions.bed.gz > ${1}.txt

Rscript --vanilla Cbeticola_average_cover.r $1
cat ${1}_highcover.txt > $1_highcover.bed

bedtools intersect -a $REF2 -b ${1}_highcover.bed | awk '$3=="gene"' > ${1}_intsct.bed
bedtools coverage -a $REF2 -b ${1}_highcover.bed | awk '$3=="gene"' > ${1}_cover.bed
cat ${1}_cover.bed | awk '$13>0.5' > ${1}_filtcover.bed
cat ${1}_intsct.bed > ${1}_intsct.txt
cat ${1}_cover.bed > ${1}_cover.txt
cat ${1}_filtcover.bed > ${1}_filtcover.txt

