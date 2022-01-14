# 

# download the raw reads
esearch -db sra -query PRJNA673877  | efetch -format runinfo > runinfo.csv
fastq-dump SRR12966166
fastq-dump -X 10000 --split-files SRR12966166

# naming the reference as a variable 
REF=~/refs/Cbeticola/GCA_002742065.1_CB0940_V2_genomic.fna
# naming the fastq files 
R1=SRR12966166_1.fastq
R2=SRR12966166_2.fastq

# indexing the reference 
bwa index ~/refs/Cbeticola/GCA_002742065.1_CB0940_V2_genomic.fna

# check the reference data
cat $REF | grep -e ">" | cut -d ' ' -f 1 | head



# QC
# fastqc 
fastqc $R1 $R2
# fastp 
fastp -i $R1 -o SRR12966166_1_QC.fastq
fastp -i $R2 -o SRR12966166_2_QC.fastq # doesn't finish
fastp -i $R1 -I $R2 -o SRR12966166_1_QC.fastq  -O SRR12966166_2_QC.fastq



#fastp -i in.R1.fq.gz -I in.R2.fq.gz -o out.R1.fq.gz -O out.R2.fq.gz
fastqc SRR12966166_1_QC.fastq SRR12966166_2_QC.fastq

# map
bwa mem $REF SRR12966166_1_QC.fastq > output.sam
# convert to bam 
# samtools 
#samtools view -S -b output.sam > output.bam
samtools sort output.sam > output.bam
samtools index output.bam

# # alternative mapping and converting to bam 
# bwa mem $REF $R1 $R2 | samtools sort > output.bam
# samtools samtools index output.bam

# check
cat output.sam | head
cat output.sam | grep -v @ | cut -f 1 | head -5

# each covarge is 40 reads 
# looking into sliding windows 
# check the mean/median coverage for entire genome 
# mos depth 
# --by window size 
mosdepth --by 1000 output output.bam

# where the window duplicated
# median for all windows 
# compare with every window 
# 2* the average 
zcat output.regions.bed.gz > output.txt

# get the regions with high coverage
# see "Cbeticola_average_cover.r"
cat output_highcover.txt > output_highcover.bed

# bedtools 
# CNVnator doesn't work in farm
bedtools intersect -a output_highcover.bed -b ../refs/Cbeticola/GCA_002742065.1_CB0940_V2_genomic.gff
bedtools intersect -a ../refs/Cbeticola/GCA_002742065.1_CB0940_V2_genomic.gff -b output_highcover.bed | awk '$3=="gene"' > output_intsct.bed



# accessing the node
srun --nodes=1 -p med -t 1:55:00 -c 2 --mem 8GB --pty /bin/bash

# SRA Explorer

