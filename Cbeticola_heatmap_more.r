setwd("/home/wang9418/Cbeticola/10_samples_more")
# library(tidyr)
# library(ggplot2)



# load the coverages 
covers_files <- list.files(pattern="SRR\\d+.txt")
covers_list <- lapply(covers_files, read.table)
names(covers_list) <- gsub(".txt", "", covers_files)

for(i in 1:length(covers_list)){
    print(nrow(covers_list[[i]]))
}
# select only the chromosomes 
for(i in 1:length(covers_list)){
    covers_list[[i]] = covers_list[[i]][grep("CM", covers_list[[i]]$V1), ]
}

# load resistence information 
resistence <- read.table("runinfo_10_res.txt")

# give names to windows 
covers_list_alt <- covers_list
for(i in 1:length(covers_list_alt)){
    names(covers_list_alt[[i]])[4] = "coverage"
    covers_list_alt[[i]]$window = paste0(covers_list_alt[[i]]$V1, 
                                        ((covers_list_alt[[i]]$V2 + covers_list_alt[[i]]$V3)/2))
}
for(i in 1:length(covers_list_alt)){
    print(nrow(covers_list_alt[[i]]))
}



# organize each sample's coverage on windows 
coverage <- covers_list_alt[[1]]$coverage
for(i in 2:length(covers_list_alt)){
    coverage = rbind(coverage, covers_list_alt[[i]]$coverage)
}
coverage <- as.matrix(coverage)
rownames(coverage) <- gsub(".txt", "", covers_files)
colnames(coverage) <- covers_list_alt[[1]]$window

write.table(coverage, "coverage_10.txt", sep="\t")

# change the coverage into ratio
coverage_ratio <- matrix(NA, nrow=nrow(coverage), ncol=ncol(coverage))
for (i in 1:10){
    coverage_ratio[i,] = coverage[i,] / mean(coverage[i,])
}
rownames(coverage_ratio) <- rownames(coverage)
colnames(coverage_ratio) <- colnames(coverage)



# select windows with highly variable coverage ratios 
coverage_filt <- apply(coverage_ratio, 2, FUN=function(x) {any(x>(1.7*median(x)) | x<(0.3*median(x)))} )
coverage_filtered <- coverage_ratio[, coverage_filt]
dim(coverage_filtered)
# 10 1695
coverage_filt_high <- apply(coverage_ratio, 2, FUN=function(x) {any(x>(1.7*median(x)))} )
coverage_filtered_high <- coverage_ratio[, coverage_filt_high]
dim(coverage_filtered_high)
# 10 944

# incoporate resistence data
coverage_filtered <- as.data.frame(coverage_filtered)
coverage_filtered$resistence[resistence$Run] <- resistence$resistence_num
coverage_filtered <- coverage_filtered[order(coverage_filtered$resistence),]
coverage_filtered <- as.matrix(coverage_filtered)
write.table(coverage_filtered, "coverage_filtered_10.txt", sep="\t")
coverage_filtered_high <- as.data.frame(coverage_filtered_high)
coverage_filtered_high$resistence[resistence$Run] <- resistence$resistence_num
coverage_filtered_high <- coverage_filtered_high[order(coverage_filtered_high$resistence),]
coverage_filtered_high <- as.matrix(coverage_filtered_high)
write.table(coverage_filtered_high, "coverage_filtered_high_10.txt", sep="\t")



# plot heatmap
pdf("heatmap.pdf")
heatmap(coverage_filtered[, 1:(ncol(coverage_filtered)-1)], scale="col", Rowv=NA)
dev.off()
pdf("heatmap_high.pdf")
heatmap(coverage_filtered_high[, 1:(ncol(coverage_filtered_high)-1)], scale="col", Rowv=NA)
dev.off()



# # gather the data
# coverage_filtered_high_gatherd <- cbind(rownames(coverage_filtered_high), as.data.frame(coverage_filtered_high))
# colnames(coverage_filtered_high_gatherd)[1] <- "name"
# coverage_filtered_high_gatherd <- as.data.frame(coverage_filtered_high_gatherd)
# coverage_filtered_high_gatherd <- gather(coverage_filtered_high_gatherd, 
#                                 key="window", value="coverage", 
#                                 2:( ncol(coverage_filtered_high_gatherd)-1 ))

# # try heatmap with ggplot
# pdf("heatmap_high_gg.pdf")
# ggplot(coverage_filtered_high_gatherd, aes(x=name, y=window, fill=coverage)) + 
#     geom_tile()
# dev.off()




# archived Nov 22
# # select windows with highly variable coverage ratios 
# coverage_filt <- apply(coverage_ratio, 2, FUN=function(x) {any(x>1.7 | x<0.3)} )
# coverage_filtered <- coverage_ratio[, coverage_filt]
# # dim(coverage_filtered)
# # 10 4338
# coverage_filt_high <- apply(coverage_ratio, 2, FUN=function(x) {any(x>1.7)} )
# coverage_filtered_high <- coverage_ratio[, coverage_filt_high]
# # dim(coverage_filtered_high)
# # 10 285



# # incoporate resistence data
# coverage_filtered <- as.data.frame(coverage_filtered)
# coverage_filtered$resistence[resistence$Run] <- resistence$resistence_num
# coverage_filtered <- coverage_filtered[order(coverage_filtered$resistence),]
# coverage_filtered <- as.matrix(coverage_filtered)
# write.table(coverage_filtered, "coverage_filtered_10.txt", sep="\t")
# coverage_filtered_high <- as.data.frame(coverage_filtered_high)
# coverage_filtered_high$resistence[resistence$Run] <- resistence$resistence_num
# coverage_filtered_high <- coverage_filtered_high[order(coverage_filtered_high$resistence),]
# coverage_filtered_high <- as.matrix(coverage_filtered_high)
# write.table(coverage_filtered_high, "coverage_filtered_high_10.txt", sep="\t")

# # plot heatmap
# pdf("heatmap.pdf")
# heatmap(coverage_filtered[, 1:(ncol(coverage_filtered)-1)], scale="row", Rowv=NA)
# dev.off()
# pdf("heatmap_high.pdf")
# heatmap(coverage_filtered_high[, 1:(ncol(coverage_filtered_high)-1)], scale="row", Rowv=NA)
# dev.off()



# # q()
# setwd("/home/wang9418/Cbeticola/10_samples_more")


# coverage <- read.table("coverage_10.txt")

# # find the coverage that doubles or halves of the median
# coverage_filt <- apply(coverage, 2, FUN=function(x) {any(x>median(x)*2 | x<median(x)/2)} )
# coverage_filt_high <- apply(coverage, 2, FUN=function(x) {any(x>median(x)*2)} )

# coverage_filtered <- coverage[, coverage_filt]
# coverage_filtered_high <- coverage[, coverage_filt_high]
# write.table(coverage_filtered, "coverage_filtered_10.txt", sep="\t")
# write.table(coverage_filtered_high, "coverage_filtered_high_10.txt", sep="\t")


# # q()
# setwd("/home/wang9418/Cbeticola/10_samples_more")
# library(pheatmap)


# coverage_filtered_high <- read.table("coverage_filtered_high_10.txt")
# resistence <- read.table("runinfo_10_res.txt")

# coverage_filtered_high$resistence[resistence$V1] <- resistence$V4
# coverage_filtered_high <- coverage_filtered_high[order(-coverage_filtered_high$resistence), ]

# coverage_filtered_high <- as.matrix(coverage_filtered_high)
# coverage_filtered_high[, c(1:4, ncol(coverage_filtered_high))]

# pdf("heatmap.pdf")
# heatmap(coverage_filtered_high[, 1:(ncol(coverage_filtered_high)-1)], scale="row", Rowv=NA)
# dev.off()

# pdf("pheatmap.pdf", width=28)
# pheatmap(coverage_filtered_high[, 1:(ncol(coverage_filtered_high)-1)], scale="row", 
#         cellwidth = 1, cluster_rows=F)
# dev.off()