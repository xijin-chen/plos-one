
# setwd("~/Documents/21Miss_RAD/code_XC")
setwd('./imputation_05')
myFiles <- list.files(pattern="*.csv")
# myFiles_RPW <- myFiles[3]
# myFiles <- myFiles[-3]
myLists <- list.files(pattern = "*.rds")
# myLists_RPW <- myLists[3]
# myLists <- myLists[-3]
names_files <- sapply(strsplit(myFiles, "\\."), "[", 1)
names_data <- paste("ENS_imp", sapply(strsplit(names_files, "_"), "[", 2), sep = "_")
data_path <- '../imp05_plots/ENS_imputation/data/'


for(nf in 1:length(myFiles)){
  mylist <-  readRDS(myLists[nf])
  maincond <- read.csv(myFiles[nf])
  
  ENS <- matrix(NA, nrow=length(mylist), ncol=1)
  ENS_se <- matrix(NA, nrow=length(mylist), ncol=1)
  
  for(i in 1:length(mylist)){
    ENS[i] <- mean((mylist[[i]])[,"S_final1"] + (mylist[[i]])[,"S_final0"])
    ENS_se[i] <- sd((mylist[[i]])[,"S_final1"] + (mylist[[i]])[,"S_final0"] )
  }
  
  ENS_result <- cbind(maincond, ENS, ENS_se)
  ENS_result <- data.frame(subset(ENS_result,select = -c(X)))
  ENS_result$scenario <- NULL
  ENS_result[ENS_result$Nt == 200 & 
               ENS_result$p0 == 0.1,"scenario"] <- 1
  ENS_result[ENS_result$Nt == 200 & 
               ENS_result$p0 == 0.3,"scenario"] <- 2
  ENS_result[ENS_result$Nt == 200 & 
               ENS_result$p0 == 0.5,"scenario"] <- 3
  ENS_result[ENS_result$Nt == 200 & 
               ENS_result$p0 == 0.7,"scenario"] <- 4
  ENS_result[ENS_result$Nt == 200 & 
               ENS_result$p0 == 0.9,"scenario"] <- 5
  ENS_result[ENS_result$Nt == 526 & 
               ENS_result$p0 == 0.1,"scenario"] <- 6
  ENS_result[ENS_result$Nt == 162 & 
               ENS_result$p0 == 0.1,"scenario"] <- 7
  ENS_result[ENS_result$Nt == 82 & 
               ENS_result$p0 == 0.1,"scenario"] <- 8
  ENS_result[ENS_result$Nt == 82 & 
               ENS_result$p0 == 0.6,"scenario"] <- 9
  ENS_result[ENS_result$Nt == 162 & 
               ENS_result$p0 == 0.7,"scenario"] <- 10
  ENS_result[ENS_result$Nt == 526 & 
               ENS_result$p0 == 0.8,"scenario"] <- 11
  ENS_result[ENS_result$Nt == 254 & 
               ENS_result$p0 == 0.4,"scenario"] <- 12
  # -----
  fileName = paste(data_path, names_data[nf],'.csv', sep = '')
  write.csv(ENS_result, fileName)
}

# ----- RPW -------

# names_files_RPW <- sapply(strsplit(myFiles_RPW, "\\."), "[", 1)
# names_data_RPW <- paste("ENS_imp", sapply(strsplit(names_files_RPW, "_"), "[", 2), sep = "_")
# 
# mylist <-  readRDS(myLists_RPW)
# maincond <- read.csv(myFiles_RPW)
# ENS <- matrix(NA, nrow=length(mylist), ncol=1)
# ENS_se <- matrix(NA, nrow=length(mylist), ncol=1)
# 
# for(i in 1:length(mylist)){
#   ENS[i] <- mean((mylist[[i]])[,"S_final1"] + (mylist[[i]])[,"S_final0"] +
#                    (mylist[[i]])[,"Miss0_S"] + (mylist[[i]])[,"Miss1_S"])
#   ENS_se[i] <- sd((mylist[[i]])[,"S_final1"] + (mylist[[i]])[,"S_final0"] +
#                     (mylist[[i]])[,"Miss0_S"] + (mylist[[i]])[,"Miss1_S"])
# }
# ENS_result <- cbind(maincond, ENS, ENS_se)
# ENS_result <- data.frame(subset(ENS_result,select = -c(X)))
# ENS_result$scenario <- NULL
# ENS_result[ENS_result$Nt == 200 & 
#              ENS_result$p0 == 0.1,"scenario"] <- 1
# ENS_result[ENS_result$Nt == 200 & 
#              ENS_result$p0 == 0.3,"scenario"] <- 2
# ENS_result[ENS_result$Nt == 200 & 
#              ENS_result$p0 == 0.5,"scenario"] <- 3
# ENS_result[ENS_result$Nt == 200 & 
#              ENS_result$p0 == 0.7,"scenario"] <- 4
# ENS_result[ENS_result$Nt == 200 & 
#              ENS_result$p0 == 0.9,"scenario"] <- 5
# ENS_result[ENS_result$Nt == 526 & 
#              ENS_result$p0 == 0.1,"scenario"] <- 6
# ENS_result[ENS_result$Nt == 162 & 
#              ENS_result$p0 == 0.1,"scenario"] <- 7
# ENS_result[ENS_result$Nt == 82 & 
#              ENS_result$p0 == 0.1,"scenario"] <- 8
# ENS_result[ENS_result$Nt == 82 & 
#              ENS_result$p0 == 0.6,"scenario"] <- 9
# ENS_result[ENS_result$Nt == 162 & 
#              ENS_result$p0 == 0.7,"scenario"] <- 10
# ENS_result[ENS_result$Nt == 526 & 
#              ENS_result$p0 == 0.8,"scenario"] <- 11
# ENS_result[ENS_result$Nt == 254 & 
#              ENS_result$p0 == 0.4,"scenario"] <- 12
# # -----
# fileName = paste(data_path, names_data_RPW,'.csv', sep = '')
# write.csv(ENS_result, fileName)
