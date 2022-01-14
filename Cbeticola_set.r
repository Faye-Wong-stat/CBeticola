setwd("/home/wang9418/Cbeticola/10_samples_more")

highcovers_files <- list.files(pattern="SRR\\d+_highcover.txt")
highcovers_list <- lapply(highcovers_files, read.table)
names(highcovers_list) <- gsub("_highcover.txt", "", highcovers_files)
resistence <- read.table("runinfo_10_res.txt")
high <- resistence[resistence[,3]=="R", 1]
low <- resistence[resistence[,3]=="S", 1]

highcovers_list_alt <- highcovers_list
for (i in 1:length(highcovers_list_alt)){
    highcovers_list_alt[[i]] = 
        highcovers_list_alt[[i]][grep("CM", highcovers_list_alt[[i]]$V1), ]
    highcovers_list_alt[[i]]$window = 
        paste0(highcovers_list_alt[[i]]$V1, as.character((highcovers_list_alt[[i]]$V2 + highcovers_list_alt[[i]]$V3)/2))
    names(highcovers_list_alt[[i]])[4] = "coverage"
}

common_window_high <- highcovers_list_alt[[high[1]]]$window
for (i in high[2:5]){
    common_window_high = intersect(common_window_high, highcovers_list_alt[[i]]$window)
}
# 94 windows 
write.table(common_window_high, "set/common_window_high.txt", 
            sep="\t", quote=F)

union_window_low <- highcovers_list_alt[[low[1]]]$window
for (i in low[2:5]){
    union_window_low = union(union_window_low, highcovers_list_alt[[i]]$window)
}
# 144
common_window_low <- highcovers_list_alt[[low[1]]]$window
for (i in low[2:5]){
    common_window_low = intersect(common_window_low, highcovers_list_alt[[i]]$window)
}
# 114
write.table(union_window_low, "set/union_window_low.txt", 
            sep="\t", quote=F)
write.table(common_window_low, "set/common_window_low.txt", 
            sep="\t", quote=F)

number_window_low <- c()
for (i in low){
    number_window_low = c(number_window_low, highcovers_list_alt[[i]]$window)
}
number_window_low <- as.data.frame(table(number_window_low))
number_window_low <- number_window_low[order(-number_window_low$Freq),]
number_window_low_4 <- number_window_low[number_window_low$Freq==4,]
# 8 + 114
number_window_low_3 <- number_window_low[number_window_low$Freq==3,]
# 7 + 114
write.table(number_window_low, "set/number_window_low.txt", 
            sep="\t", quote=F)



# the intersection of highs that is not presentated in any lows
setdiff(common_window_high, union_window_low)
# only 1
# "CM008508.1853500"

# the intersection of highs and lows
intersect(common_window_high, common_window_low)
# 91


# union of H - union of L 
# look at what that window is 




# create a heatmap 