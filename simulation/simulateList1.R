
# -------simulation setup -----------
maincond <- read.csv("maincond1_all.csv")
names <- matrix(NA,nrow = nrow(maincond), ncol = 1)
mylist <- list()

# currently 12*36*1= 432 simulations
for(i in 1:nrow(maincond)){
  name <-  paste0("sim_",as.character(maincond$method[i]),"_",i)
  tmp <- matrix(NA, nrow = maincond$Nt[i], ncol = 1)
  mylist[[name]] <- tmp
}

# -------simulation--------
for(i in 1:nrow(maincond)){
  # simulation settings
  N = 10000L      
  Nt = maincond$Nt[i]  
  method_name = maincond$method[i] 
  pmiss0 = maincond$miss0[i] 
  pmiss1 = maincond$miss1[i]
  p0 = maincond$p0[i]
  p1 = maincond$p1[i]
  reticulate::source_python("simulation1.py")
  
  # list of outcomes
  S_observe = matrix(unlist(S_observe), ncol=2, byrow=TRUE)
  F_observe = matrix(unlist(F_observe), ncol=2, byrow=TRUE)
  N_miss = matrix(unlist(N_miss), ncol=2, byrow=TRUE)
  N1 = matrix(unlist(N1), ncol=1, byrow=TRUE)
  
  outcome <- data.frame(cbind(S_observe, F_observe, 
                              N_miss, N1))
  colnames(outcome) <- c("S_obs0","S_obs1","F_obs0","F_obs1",
                         "N_miss0","N_miss1","N1")
  name <-  paste0("sim_",as.character(maincond$method[i]),"_",i)
  mylist[[name]] <- outcome
}

saveRDS(mylist, 'mylist_simulation1.rds')
