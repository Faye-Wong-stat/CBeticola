setwd("~/Desktop/Stergiopoulos Lab/Data/Cbeticola/")
library(stringr)
library(tidyr)
library(ggplot2)

intsct1 <- read.table("first_sample/output_intsct.txt")
intsct2 <- read.table("second_sample/output_intsct.txt")
cover1 <- read.table("first_sample/output.txt")
cover2 <- read.table("second_sample/output.txt")
filtcover1 <- read.table("first_sample/output_filtcover.txt")
filtcover2 <- read.table("second_sample/output_filtcover.txt")

cover1 <- cover1[str_detect(cover1$V1, "CM"), ]
cover2 <- cover2[str_detect(cover2$V1, "CM"), ]
cover1$position <- (cover1$V2+cover1$V3)/2
cover2$position <- (cover2$V2+cover2$V3)/2
names(cover1)[4] <- "coverage"
names(cover2)[4] <- "coverage"

filtcover1$gene_name <- gsub(";.+", "", gsub(".+-", "", filtcover1$V9))
filtcover2$gene_name <- gsub(";.+", "", gsub(".+-", "", filtcover2$V9))
names(filtcover1)[13] <- "cover_perc"
names(filtcover2)[13] <- "cover_perc"

filtcover <- merge(filtcover1[, 13:14], filtcover2[, 13:14], by="gene_name")
names(filtcover)[2:3] <- c("sampleA", "sampleB")
filtcover <- gather(filtcover, "sample", "cover_perc", 2:3)

pdf("plots/sampleA_chr1_coverage.pdf")
ggplot(cover1[cover1$V1=="CM008499.1",], aes(x=position, y=coverage)) + 
  geom_line() #+ facet_grid(~V1)
dev.off()

pdf("plots/two_samples_coverage.pdf")
ggplot(filtcover, aes(x=gene_name, y=cover_perc, fill=sample)) + 
  geom_bar(stat="identity", position=position_dodge())
dev.off()
