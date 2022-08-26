
# 

setwd('./simulation')
myFiles <- list.files(pattern=".csv")
myLists <- list.files(pattern = ".rds") 
myLists <- myLists[2:5]
names_files <- sapply(strsplit(myFiles, "\\."), "[", 1)
names_data <- paste("bias", sapply(strsplit(names_files, "_"), "[", 2), sep = "_")
data_path <- '../sim_plots/data_sim/'

for(nf in 1:length(myFiles)){
  mylist <-  readRDS(myLists[nf])
  maincond <- read.csv(myFiles[nf])
  
  bias0 <- matrix(NA, nrow=length(mylist), ncol=1)
  bias1 <- matrix(NA, nrow=length(mylist), ncol=1)
  
  
  for(i in 1:length(mylist)){
    if(nf==3){
      colnames(mylist[[i]]) <- c("S_obs0", "S_obs1", "F_obs0", "F_obs1",
                                 "N_miss0",  "N_miss1")
    }
    
    bias0[i] <- mean(mylist[[i]][,"S_obs0"]/(mylist[[i]][,"S_obs0"]+mylist[[i]][,"F_obs0"]), na.rm = T) - maincond$p0[i]
    bias1[i] <- mean(mylist[[i]][,"S_obs1"]/(mylist[[i]][,"S_obs1"]+mylist[[i]][,"F_obs1"]), na.rm = T) - maincond$p1[i]
  }
  
  bias_result <- cbind(maincond, bias0, bias1)
  bias_result <- data.frame(subset(bias_result,select = -c(X)))
  bias_result$scenario <- NULL
  bias_result[bias_result$Nt == 200 & 
                  bias_result$p0 == 0.1,"scenario"] <- 1
  bias_result[bias_result$Nt == 200 & 
                  bias_result$p0 == 0.3,"scenario"] <- 2
  bias_result[bias_result$Nt == 200 & 
                  bias_result$p0 == 0.5,"scenario"] <- 3
  bias_result[bias_result$Nt == 200 & 
                  bias_result$p0 == 0.7,"scenario"] <- 4
  bias_result[bias_result$Nt == 200 & 
                  bias_result$p0 == 0.9,"scenario"] <- 5
  bias_result[bias_result$Nt == 526 & 
                  bias_result$p0 == 0.1,"scenario"] <- 6
  bias_result[bias_result$Nt == 162 & 
                  bias_result$p0 == 0.1,"scenario"] <- 7
  bias_result[bias_result$Nt == 82 & 
                  bias_result$p0 == 0.1,"scenario"] <- 8
  bias_result[bias_result$Nt == 82 & 
                  bias_result$p0 == 0.6,"scenario"] <- 9
  bias_result[bias_result$Nt == 162 & 
                  bias_result$p0 == 0.7,"scenario"] <- 10
  bias_result[bias_result$Nt == 526 & 
                  bias_result$p0 == 0.8,"scenario"] <- 11
  bias_result[bias_result$Nt == 254 & 
                  bias_result$p0 == 0.4,"scenario"] <- 12
  
  fileName = paste(data_path, names_data[nf],'.csv', sep = '')
  write.csv(bias_result, fileName)
}

# -----
