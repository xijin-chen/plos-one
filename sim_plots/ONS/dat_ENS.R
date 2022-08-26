
# setwd("~/Documents/21Miss_RAD/code_XC/simulation")
myFiles <- list.files(pattern="*.csv")
myFiles_RPW <- myFiles[3]
myFiles <- myFiles[-3]
myLists <- list.files(pattern = "_simulation")
myLists_RPW <- myLists[3]
myLists <- myLists[-3]
names_files <- sapply(strsplit(myFiles, "\\."), "[", 1)
names_data <- paste("ONS", sapply(strsplit(names_files, "_"), "[", 2), sep = "_")
data_path <- '../sim_plots/ONS/data/'


for(nf in 1:length(myFiles)){
  mylist <-  readRDS(myLists[nf])
  maincond <- read.csv(myFiles[nf])
  
  ONS <- matrix(NA, nrow=length(mylist), ncol=1)
  ONS_se <- matrix(NA, nrow=length(mylist), ncol=1)
  
  for(i in 1:length(mylist)){
    ONS[i] <- mean((mylist[[i]])[,"S_obs1"] + (mylist[[i]])[,"S_obs0"])
    ONS_se[i] <- sd((mylist[[i]])[,"S_obs1"] + (mylist[[i]])[,"S_obs0"])
  }
  
  ONS_result <- cbind(maincond, ONS, ONS_se)
  ONS_result <- data.frame(subset(ONS_result,select = -c(X)))
  ONS_result$scenario <- NULL
  ONS_result[ONS_result$Nt == 200 & 
               ONS_result$p0 == 0.1,"scenario"] <- 1
  ONS_result[ONS_result$Nt == 200 & 
               ONS_result$p0 == 0.3,"scenario"] <- 2
  ONS_result[ONS_result$Nt == 200 & 
               ONS_result$p0 == 0.5,"scenario"] <- 3
  ONS_result[ONS_result$Nt == 200 & 
               ONS_result$p0 == 0.7,"scenario"] <- 4
  ONS_result[ONS_result$Nt == 200 & 
               ONS_result$p0 == 0.9,"scenario"] <- 5
  ONS_result[ONS_result$Nt == 526 & 
               ONS_result$p0 == 0.1,"scenario"] <- 6
  ONS_result[ONS_result$Nt == 162 & 
               ONS_result$p0 == 0.1,"scenario"] <- 7
  ONS_result[ONS_result$Nt == 82 & 
               ONS_result$p0 == 0.1,"scenario"] <- 8
  ONS_result[ONS_result$Nt == 82 & 
               ONS_result$p0 == 0.6,"scenario"] <- 10
  ONS_result[ONS_result$Nt == 162 & 
               ONS_result$p0 == 0.7,"scenario"] <- 11
  ONS_result[ONS_result$Nt == 526 & 
               ONS_result$p0 == 0.8,"scenario"] <- 12
  ONS_result[ONS_result$Nt == 254 & 
               ONS_result$p0 == 0.4,"scenario"] <- 9
  # -----
  fileName = paste(data_path, names_data[nf],'.csv', sep = '')
  write.csv(ONS_result, fileName)
}

# ----- RPW -------

names_files_RPW <- sapply(strsplit(myFiles_RPW, "\\."), "[", 1)
names_data_RPW <- paste("ONS", sapply(strsplit(names_files_RPW, "_"), "[", 2), sep = "_")

mylist <-  readRDS(myLists_RPW)
maincond <- read.csv(myFiles_RPW)
ONS <- matrix(NA, nrow=length(mylist), ncol=1)
ONS_se <- matrix(NA, nrow=length(mylist), ncol=1)

for(i in 1:length(mylist)){
  ONS[i] <- mean((mylist[[i]])[,"S_final1"] + (mylist[[i]])[,"S_final0"])
  ONS_se[i] <- sd((mylist[[i]])[,"S_final1"] + (mylist[[i]])[,"S_final0"])
}
ONS_result <- cbind(maincond, ONS, ONS_se)
ONS_result <- data.frame(subset(ONS_result,select = -c(X)))
ONS_result$scenario <- NULL
ONS_result[ONS_result$Nt == 200 & 
             ONS_result$p0 == 0.1,"scenario"] <- 1
ONS_result[ONS_result$Nt == 200 & 
             ONS_result$p0 == 0.3,"scenario"] <- 2
ONS_result[ONS_result$Nt == 200 & 
             ONS_result$p0 == 0.5,"scenario"] <- 3
ONS_result[ONS_result$Nt == 200 & 
             ONS_result$p0 == 0.7,"scenario"] <- 4
ONS_result[ONS_result$Nt == 200 & 
             ONS_result$p0 == 0.9,"scenario"] <- 5
ONS_result[ONS_result$Nt == 526 & 
             ONS_result$p0 == 0.1,"scenario"] <- 6
ONS_result[ONS_result$Nt == 162 & 
             ONS_result$p0 == 0.1,"scenario"] <- 7
ONS_result[ONS_result$Nt == 82 & 
             ONS_result$p0 == 0.1,"scenario"] <- 8
ONS_result[ONS_result$Nt == 82 & 
             ONS_result$p0 == 0.6,"scenario"] <- 10
ONS_result[ONS_result$Nt == 162 & 
             ONS_result$p0 == 0.7,"scenario"] <- 11
ONS_result[ONS_result$Nt == 526 & 
             ONS_result$p0 == 0.8,"scenario"] <- 12
ONS_result[ONS_result$Nt == 254 & 
             ONS_result$p0 == 0.4,"scenario"] <- 9
# -----
fileName = paste(data_path, names_data_RPW,'.csv', sep = '')
write.csv(ONS_result, fileName)
