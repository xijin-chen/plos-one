# 
setwd('./simulation')
myFiles <- list.files(pattern="*.csv")
myFiles <- myFiles[-3]
myLists <- list.files(pattern = "*.rds") 
myLists <- myLists[-3]
names_files <- sapply(strsplit(myFiles, "\\."), "[", 1)
names_data <- paste("ENS", sapply(strsplit(names_files, "_"), "[", 2), sep = "_")
names_data2 <- paste("POS", sapply(strsplit(names_files, "_"), "[", 2), sep = "_")
names_data3 <- paste("PES", sapply(strsplit(names_files, "_"), "[", 2), sep = "_")

data_path <- '../sim_plots/data_sim/'

for(nf in 1:length(myFiles)){
  mylist <-  readRDS(myLists[nf])
  maincond <- read.csv(myFiles[nf])
  
  ENS <- matrix(NA, nrow=length(mylist), ncol=1)
  ENS_se <- matrix(NA, nrow=length(mylist), ncol=1)
  POS <- matrix(NA, nrow=length(mylist), ncol=1)
  POS_se <- matrix(NA, nrow=length(mylist), ncol=1)
  PES <- matrix(NA, nrow=length(mylist), ncol=1)
  PES_se <- matrix(NA, nrow=length(mylist), ncol=1)
  
  for(i in 1:length(mylist)){
    ENS[i] <- mean((mylist[[i]])[,"S_obs1"] + (mylist[[i]])[,"S_obs0"])
    ENS_se[i] <- sd((mylist[[i]])[,"S_obs1"] + (mylist[[i]])[,"S_obs0"])
    
    POS <- mean(((mylist[[i]])[,"S_obs1"] + (mylist[[i]])[,"S_obs0"])/
                  ((mylist[[i]])[,"S_obs1"] + (mylist[[i]])[,"S_obs0"]+
                     (mylist[[i]])[,"F_obs1"] + (mylist[[i]])[,"F_obs0"]))
    POS_se <- sd(((mylist[[i]])[,"S_obs1"] + (mylist[[i]])[,"S_obs0"])/
                   ((mylist[[i]])[,"S_obs1"] + (mylist[[i]])[,"S_obs0"]+
                      (mylist[[i]])[,"F_obs1"] + (mylist[[i]])[,"F_obs0"]))
    
    PES <- mean(((mylist[[i]])[,"S_obs1"] + (mylist[[i]])[,"S_obs0"])/
                  (maincond[i,'Nt']))
    PES_se <- sd(((mylist[[i]])[,"S_obs1"] + (mylist[[i]])[,"S_obs0"])/
                   (maincond[i,'Nt']))
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
  # ----
  POS_result <- cbind(maincond, POS, POS_se)
  POS_result <- data.frame(subset(POS_result,select = -c(X)))
  POS_result$scenario <- NULL
  POS_result[POS_result$Nt == 200 & 
               POS_result$p0 == 0.1,"scenario"] <- 1
  POS_result[POS_result$Nt == 200 & 
               POS_result$p0 == 0.3,"scenario"] <- 2
  POS_result[POS_result$Nt == 200 & 
               POS_result$p0 == 0.5,"scenario"] <- 3
  POS_result[POS_result$Nt == 200 & 
               POS_result$p0 == 0.7,"scenario"] <- 4
  POS_result[POS_result$Nt == 200 & 
               POS_result$p0 == 0.9,"scenario"] <- 5
  POS_result[POS_result$Nt == 526 & 
               POS_result$p0 == 0.1,"scenario"] <- 6
  POS_result[POS_result$Nt == 162 & 
               POS_result$p0 == 0.1,"scenario"] <- 7
  POS_result[POS_result$Nt == 82 & 
               POS_result$p0 == 0.1,"scenario"] <- 8
  POS_result[POS_result$Nt == 82 & 
               POS_result$p0 == 0.6,"scenario"] <- 9
  POS_result[POS_result$Nt == 162 & 
               POS_result$p0 == 0.7,"scenario"] <- 10
  POS_result[POS_result$Nt == 526 & 
               POS_result$p0 == 0.8,"scenario"] <- 11
  POS_result[POS_result$Nt == 254 & 
               POS_result$p0 == 0.4,"scenario"] <- 12
  # ----
  PES_result <- cbind(maincond, PES, PES_se)
  PES_result <- data.frame(subset(PES_result,select = -c(X)))
  PES_result$scenario <- NULL
  PES_result[PES_result$Nt == 200 & 
               PES_result$p0 == 0.1,"scenario"] <- 1
  PES_result[PES_result$Nt == 200 & 
               PES_result$p0 == 0.3,"scenario"] <- 2
  PES_result[PES_result$Nt == 200 & 
               PES_result$p0 == 0.5,"scenario"] <- 3
  PES_result[PES_result$Nt == 200 & 
               PES_result$p0 == 0.7,"scenario"] <- 4
  PES_result[PES_result$Nt == 200 & 
               PES_result$p0 == 0.9,"scenario"] <- 5
  PES_result[PES_result$Nt == 526 & 
               PES_result$p0 == 0.1,"scenario"] <- 6
  PES_result[PES_result$Nt == 162 & 
               PES_result$p0 == 0.1,"scenario"] <- 7
  PES_result[PES_result$Nt == 82 & 
               PES_result$p0 == 0.1,"scenario"] <- 8
  PES_result[PES_result$Nt == 82 & 
               PES_result$p0 == 0.6,"scenario"] <- 9
  PES_result[PES_result$Nt == 162 & 
               PES_result$p0 == 0.7,"scenario"] <- 10
  PES_result[PES_result$Nt == 526 & 
               PES_result$p0 == 0.8,"scenario"] <- 11
  PES_result[PES_result$Nt == 254 & 
               PES_result$p0 == 0.4,"scenario"] <- 12
  # -----
  fileName = paste(data_path, names_data[nf],'.csv', sep = '')
  write.csv(ENS_result, fileName)
  fileName2 = paste(data_path, names_data2[nf],'.csv', sep = '')
  write.csv(POS_result, fileName2)
  fileName3 = paste(data_path, names_data3[nf],'.csv', sep = '')
  write.csv(PES_result, fileName3)
}

