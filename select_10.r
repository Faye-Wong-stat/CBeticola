setwd("~/Cbeticola/10_samples/")
runinfo <- read.csv("../runinfo.csv")

runinfo_10 <- runinfo[runinfo$SampleName %in% c("16-F48", "16-F57", "16-46", "16-92", 
                                                "16-175", "16-591", "16-665", "16-735", 
                                                "16-781", "16-787"), ]

runinfo_10 <- runinfo_10[,1]
write.table(runinfo_10, "runinfo_10.txt", sep="\t", row.names=F, col.names=F, quote=F)

runinfo_10_res <- runinfo_10[,c("Run", "SampleName")]
runinfo_10_res$resistence <- c(rep("H", 5), rep("L", 5))
runinfo_10_res$resistence_num <- c(61.118, 80.749, 59.412, 64.56, 83.875, 0.395, 0.371, 0.403, 0.205, 0.455)
write.table(runinfo_10_res, "runinfo_10_res.txt", sep="\t", row.names=F, col.names=F, quote=F)