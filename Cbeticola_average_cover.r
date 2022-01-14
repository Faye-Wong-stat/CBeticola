args <- commandArgs(trailingOnly = TRUE)
if (length(args) == 0) {
  stop("At least one argument must be supplied (input file).\n", call. = FALSE)
} else {
  print(paste0("Arg input:  ", args[1]))
}



output <- read.table(paste0(args[1], ".txt"), header=F)
# head(output)
avg <- mean(output[,4])
med <- median(output[,4])
output_highcover <- output[output[,4] > (2*avg),]
writeLines(paste("mean", avg, "median", med, sep=" "), paste0(args[1], "_mean_med.txt"))
# add a table with lowcover 
write.table(output_highcover, paste0(args[1], "_highcover.txt"), 
            sep="\t", row.names=F, col.names=F, quote=F)