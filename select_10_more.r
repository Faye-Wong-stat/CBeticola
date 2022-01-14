setwd("~/Cbeticola/10_samples_more/")
runinfo <- read.csv("../runinfo.csv")

runinfo_10 <- runinfo[runinfo$SampleName 
                    %in% c("16-F32", "16-F48", "16-46", "16-339", 
                            "16-591", "16-665", "16-805", "16-317", 
                            "16-790", "16-224"), ]

runinfo_10 <- runinfo_10[,1]
write.table(runinfo_10, "runinfo_10.txt", sep="\t", row.names=F, col.names=F, quote=F)

runinfo_10_res <- runinfo_10[,c("Run", "SampleName")]
runinfo_10_res$resistence <- c("S", rep("R", 2), rep("S", 4), rep("R", 3))
runinfo_10_res$resistence_num <- c(0.443, 61.118, 59.412, 0.067, 0.395, 0.371, 0.404, 65.277, 77.542, 83.546)
write.table(runinfo_10_res, "runinfo_10_res.txt", sep="\t", quote=F)