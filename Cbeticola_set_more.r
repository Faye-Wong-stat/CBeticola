setwd("/home/wang9418/Cbeticola/10_samples_more")

highcovers_files <- list.files(pattern="SRR\\d+_highcover.txt")
highcovers_list <- lapply(highcovers_files, read.table)
names(highcovers_list) <- gsub("_highcover.txt", "", highcovers_files)
resistence <- read.table("runinfo_10_res.txt")
high <- as.character(resistence[resistence[,3]=="R", 1])
low <- as.character(resistence[resistence[,3]=="S", 1])

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
length(common_window_high)
# 97 windows 
write.table(common_window_high, "set/common_window_high.txt", 
            sep="\t", quote=F)
union_window_high <- highcovers_list_alt[[high[1]]]$window
for (i in high[2:5]){
    union_window_high = union(union_window_high, highcovers_list_alt[[i]]$window)
}
length(union_window_high)
# 201
write.table(union_window_high, "set/union_window_high.txt", 
            sep="\t", quote=F)

union_window_low <- highcovers_list_alt[[low[1]]]$window
for (i in low[2:5]){
    union_window_low = union(union_window_low, highcovers_list_alt[[i]]$window)
}
length(union_window_low)
# 177
common_window_low <- highcovers_list_alt[[low[1]]]$window
for (i in low[2:5]){
    common_window_low = intersect(common_window_low, highcovers_list_alt[[i]]$window)
}
length(common_window_low)
# 93
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
dim(number_window_low_4)
# 23 + 93
number_window_low_3 <- number_window_low[number_window_low$Freq==3,]
dim(number_window_low_3)
# 7 + 23 + 93
write.table(number_window_low, "set/number_window_low.txt", 
            sep="\t", quote=F)



# the intersection of highs that is not presentated in any lows
setdiff(common_window_high, union_window_low)
# none

# the intersection of highs and lows
intersect(common_window_high, common_window_low)
# 87

# the intersection of highs that is only presentated in 1 low
setdiff(common_window_high, number_window_low[number_window_low$Freq==5 | number_window_low$Freq==4,1])
# 3
# "CM008500.13599500" "CM008503.1784500"  "CM008508.1853500" 
write.table(setdiff(common_window_high, number_window_low[number_window_low$Freq==5 | number_window_low$Freq==4,1]), 
            "set/inter_high_only_1_low.txt", row.names=F, col.names=F, sep="\t", quote=F)

# the intersection of highs that is only presentated in 1 or 2 low(s)
setdiff(common_window_high, number_window_low[number_window_low$Freq==5 | number_window_low$Freq==4 | number_window_low$Freq==3,1])
# 3
# "CM008500.13599500" "CM008503.1784500"  "CM008508.1853500" 

# union of H - union of L 
# the union of highs that is not presentated in any lows
setdiff(union_window_high, union_window_low)
# 42
#  [1] "CM008499.14115500" "CM008500.11026500" "CM008500.11034500"
#  [4] "CM008500.11314500" "CM008500.11488500" "CM008500.11565500"
#  [7] "CM008500.11566500" "CM008500.11671500" "CM008500.12487500"
# [10] "CM008500.12488500" "CM008501.12473500" "CM008501.13851500"
# [13] "CM008502.11805500" "CM008502.11998500" "CM008502.12422500"
# [16] "CM008502.12423500" "CM008502.12424500" "CM008502.12425500"
# [19] "CM008502.12434500" "CM008503.1487500"  "CM008503.13255500"
# [22] "CM008504.1734500"  "CM008505.1260500"  "CM008505.1522500" 
# [25] "CM008505.1946500"  "CM008505.1954500"  "CM008506.1608500" 
# [28] "CM008508.11135500" "CM008500.11527500" "CM008505.1930500" 
# [31] "CM008505.12037500" "CM008507.1322500"  "CM008507.11230500"
# [34] "CM008499.13850500" "CM008500.11552500" "CM008500.11687500"
# [37] "CM008500.11688500" "CM008501.12471500" "CM008501.12472500"
# [40] "CM008506.11043500" "CM008506.12009500" "CM008507.11844500"

# q()



# setwd("/home/wang9418/Cbeticola/10_samples_more")
# cover_SRR12966174 <- read.table("SRR12966174.txt")
# cover_SRR12966174 <- cover_SRR12966174[grep("CM", cover_SRR12966174$V1), ]
# cover_SRR12966174$V5 <- paste0(cover_SRR12966174$V1, 
#     as.character( (cover_SRR12966174$V2+cover_SRR12966174$V3)/2 ))

# A <- cover_SRR12966174[which(cover_SRR12966174$V5 %in% c("CM008500.13599500", "CM008503.1784500", "CM008508.1853500")),]
# A <- A[,1:4]
# write.table(A, "set/A.txt", sep="\t", row.names=F, col.names=F, quote=F)


# bin/bash
# cd ~/Cbeticola/10_samples_more
# cat set/A.txt > set/A.bed
# REF2=~/refs/Cbeticola/GCA_002742065.1_CB0940_V2_genomic.gff
# bedtools intersect -a $REF2 -b set/A.bed > set/A_intsct.bed
# cat set/A_intsct.bed > set/A_intsct.txt

