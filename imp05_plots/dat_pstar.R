# 
# setwd("~/Documents/21Miss_RAD/code_XC")
setwd('./imputation_05')
myFiles <- list.files(pattern="*.csv")
myLists <- list.files(pattern = "*.rds") 
names_files <- sapply(strsplit(myFiles, "\\."), "[", 1)
names_data <- paste("pstar", sapply(strsplit(names_files, "_"), "[", 2), sep = "_")
data_path <- '../imp05_plots/data_imp/'

for(nf in 1:length(myFiles)){
  mylist <-  readRDS(myLists[nf])
  maincond <- read.csv(myFiles[nf])
  
  pstar1 <- matrix(NA, nrow=length(mylist), ncol=1)
  pstar1_se <- matrix(NA, nrow=length(mylist), ncol=1)
  
  for(i in 1:length(mylist)){
    pstar1[i] <- mean((mylist[[i]])[,"N1"]/maincond$Nt[i])
    pstar1_se[i] <- sd((mylist[[i]])[,"N1"]/maincond$Nt[i])
  }
  
  pstars_result <- cbind(maincond, pstar1, pstar1_se)
  pstars_result <- data.frame(subset(pstars_result,select = -c(X)))
  pstars_result$scenario <- NULL
  pstars_result[pstars_result$Nt == 200 & 
                  pstars_result$p0 == 0.1,"scenario"] <- 1
  pstars_result[pstars_result$Nt == 200 & 
                  pstars_result$p0 == 0.3,"scenario"] <- 2
  pstars_result[pstars_result$Nt == 200 & 
                  pstars_result$p0 == 0.5,"scenario"] <- 3
  pstars_result[pstars_result$Nt == 200 & 
                  pstars_result$p0 == 0.7,"scenario"] <- 4
  pstars_result[pstars_result$Nt == 200 & 
                  pstars_result$p0 == 0.9,"scenario"] <- 5
  pstars_result[pstars_result$Nt == 526 & 
                  pstars_result$p0 == 0.1,"scenario"] <- 6
  pstars_result[pstars_result$Nt == 162 & 
                  pstars_result$p0 == 0.1,"scenario"] <- 7
  pstars_result[pstars_result$Nt == 82 & 
                  pstars_result$p0 == 0.1,"scenario"] <- 8
  pstars_result[pstars_result$Nt == 82 & 
                  pstars_result$p0 == 0.6,"scenario"] <- 10
  pstars_result[pstars_result$Nt == 162 & 
                  pstars_result$p0 == 0.7,"scenario"] <- 11
  pstars_result[pstars_result$Nt == 526 & 
                  pstars_result$p0 == 0.8,"scenario"] <- 12
  pstars_result[pstars_result$Nt == 254 & 
                  pstars_result$p0 == 0.4,"scenario"] <- 9
  
  fileName = paste(data_path, names_data[nf],'.csv', sep = '')
  write.csv(pstars_result, fileName)
}
