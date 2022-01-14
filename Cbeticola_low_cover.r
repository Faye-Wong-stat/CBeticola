setwd("~/Cbeticola/10_samples")

coverage_list <- list.files(pattern="SRR\\d+.txt")
coverages <- lapply(coverage_list, read.table)
names(coverages) <- gsub(".txt", "", coverage_list)
# for (i in 1:length(coverage_list)){
#     assign(gsub(".txt", "", coverage_list[i]), read.table(coverage_list[i]))
# }

means <- c()
for (i in 1:length(coverages)){
    means[i] = mean(coverages[[i]][, 4])
}

coverages_low <- list()
for (i in 1:length(coverages)){
    coverages_low[[i]] = coverages[[i]][coverages[[i]][,4] < (means[i]/2), ]
}

for (i in 1:length(coverages_low)){
    write.table(coverages_low[[i]], paste0(gsub(".txt", "", coverage_list[i]), "_lowcover.txt"), 
                sep="\t", row.names=F, col.names=F, quote=F)
}