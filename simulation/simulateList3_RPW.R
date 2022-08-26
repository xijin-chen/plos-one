
# -------simulation setup -----------
maincond <- read.csv("maincond3_RPW.csv")
names <- matrix(NA,nrow = nrow(maincond), ncol = 1)
mylist <- list()

for(i in 1:nrow(maincond)){
  name <- paste0("sim_",as.character(maincond$method[i]),"_",i)
  tmp <- matrix(NA, nrow = maincond$Nt[i], ncol = 1)
  mylist[[name]] <- tmp
}

# -------simulation--------
for(i in 1:nrow(maincond)){
  N = 10000L
  Nt= maincond$Nt[i] 
  pmiss0 = maincond$miss0[i]
  pmiss1 = maincond$miss1[i]
  p0 = maincond$p0[i]
  p1 = maincond$p1[i]
  reticulate::source_python("simulation3_RPW.py")
  
  ### list of outcomes
  S_final = matrix(unlist(S_final), ncol=2, byrow=TRUE)
  F_final = matrix(unlist(F_final), ncol=2, byrow=TRUE)
  N_miss0 = matrix(unlist(N_miss0), ncol=1, byrow=TRUE)
  N_miss1 = matrix(unlist(N_miss1), ncol=1, byrow=TRUE)
  N1 = matrix(unlist(N1), ncol=1, byrow=TRUE)
  
  outcome <- data.frame(cbind(S_final, F_final,
                              N_miss0, N_miss1,
                              N1))
  colnames(outcome) <- c("S_final0","S_final1","F_final0","F_final1",
                         "N_miss0", "N_miss1",
                         "N1")
  name <- paste0("sim_",as.character(maincond$method[i]),"_",i)
  mylist[[name]] <- outcome
}

saveRDS(mylist, 'mylist_simulation3_RPW.rds')
