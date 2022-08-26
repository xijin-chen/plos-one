
# -------imputation setup -----------
maincond <- read.csv("maincond3_RPW.csv")
names <- matrix(NA,nrow = nrow(maincond), ncol = 1)
mylist <- list()

for(i in 1:nrow(maincond)){
  name <- paste0("imp_",as.character(maincond$method[i]),"_",i)
  tmp <- matrix(NA, nrow = maincond$Nt[i], ncol = 1)
  mylist[[name]] <- tmp
}

# -------imputation--------
for(i in 1:nrow(maincond)){
  N = 10000L
  Nt= maincond$Nt[i] 
  pmiss0 = maincond$miss0[i]
  pmiss1 = maincond$miss1[i]
  p0 = maincond$p0[i]
  p1 = maincond$p1[i]
  reticulate::source_python("imputation3_RPW.py")
  
  ### list of outcomes
  S_observe = matrix(unlist(S_observe), ncol=2, byrow=TRUE)
  F_observe = matrix(unlist(F_observe), ncol=2, byrow=TRUE)
  S_impute = matrix(unlist(S_impute), ncol=2, byrow=TRUE)
  F_impute = matrix(unlist(F_impute), ncol=2, byrow=TRUE)
  S_final = matrix(unlist(S_final), ncol=2, byrow=TRUE)
  F_final = matrix(unlist(F_final), ncol=2, byrow=TRUE)
  N_miss = matrix(unlist(N_miss), ncol=2, byrow=TRUE)
  N1 = matrix(unlist(N1), ncol=1, byrow=TRUE)
  
  outcome <- data.frame(cbind(S_final, F_final,
                              S_observe, F_observe, 
                              S_impute, F_impute,
                              N_miss, N1))
  colnames(outcome) <- c("S_final0","S_final1","F_final0","F_final1",
                         "S_obs0","S_obs1","F_obs0","F_obs1",
                         "S_imp0","S_imp1","F_imp0","F_imp1",
                         "N_miss0","N_miss1","N1")
  name <- paste0("imp_",as.character(maincond$method[i]),"_",i)
  mylist[[name]] <- outcome
}

saveRDS(mylist, 'mylist_imputation3_RPW_05.rds')
