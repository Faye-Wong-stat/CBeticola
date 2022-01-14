setwd("/home/wang9418/Cbeticola/10_samples")



covers_files <- list.files(pattern="SRR\\d+.txt")
covers_list <- lapply(covers_files, read.table)
names(covers_list) <- gsub(".txt", "", covers_files)

for(i in 1:length(covers_list)){
    print(nrow(covers_list[[i]]))
}
for(i in 1:length(covers_list)){
    covers_list[[i]] = covers_list[[i]][grep("CM", covers_list[[i]]$V1), ]
}

resistence <- read.table("runinfo_10_res.txt")

covers_list_alt <- covers_list
for(i in 1:length(covers_list_alt)){
    names(covers_list_alt[[i]])[4] = "coverage"
    covers_list_alt[[i]]$window = paste0(covers_list_alt[[i]]$V1, 
                                        ((covers_list_alt[[i]]$V2 + covers_list_alt[[i]]$V3)/2))
}
for(i in 1:length(covers_list_alt)){
    print(nrow(covers_list_alt[[i]]))
}

coverage <- covers_list_alt[[1]]$coverage
for(i in 2:length(covers_list_alt)){
    coverage = rbind(coverage, covers_list_alt[[i]]$coverage)
}
coverage <- as.data.frame(coverage)
rownames(coverage) <- gsub(".txt", "", covers_files)
colnames(coverage) <- covers_list_alt[[1]]$window

write.table(coverage, "coverage_10.txt", sep="\t")





# q()
setwd("/home/wang9418/Cbeticola/10_samples")


coverage <- read.table("coverage_10.txt")

# find the coverage that doubles or halves of the median
coverage_filt <- apply(coverage, 2, FUN=function(x) {any(x>median(x)*2 | x<median(x)/2)} )
coverage_filt_high <- apply(coverage, 2, FUN=function(x) {any(x>median(x)*2)} )

coverage_filtered <- coverage[, coverage_filt]
coverage_filtered_high <- coverage[, coverage_filt_high]
write.table(coverage_filtered, "coverage_filtered_10.txt", sep="\t")
write.table(coverage_filtered_high, "coverage_filtered_high_10.txt", sep="\t")




# q()
setwd("/home/wang9418/Cbeticola/10_samples")
library(pheatmap)


coverage_filtered_high <- read.table("coverage_filtered_high_10.txt")
resistence <- read.table("runinfo_10_res.txt")

coverage_filtered_high$resistence[resistence$V1] <- resistence$V4
coverage_filtered_high <- coverage_filtered_high[order(-coverage_filtered_high$resistence), ]

coverage_filtered_high <- as.matrix(coverage_filtered_high)
coverage_filtered_high[, c(1:4, ncol(coverage_filtered_high))]

pdf("heatmap.pdf")
heatmap(coverage_filtered_high[, 1:(ncol(coverage_filtered_high)-1)], scale="row", Rowv=NA)
dev.off()

pdf("pheatmap.pdf", width=28)
pheatmap(coverage_filtered_high[, 1:(ncol(coverage_filtered_high)-1)], scale="row", 
        cellwidth = 1, cluster_rows=F)
dev.off()