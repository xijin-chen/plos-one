

my_signif = function(x, digits=2) floor(x) + signif(x %% 1, digits)
colfunc <- colorRampPalette(c("red","yellow","springgreen","royalblue"))

# transform the result into a matrix for visualization
result_matrix <- function(result, method, Nt, p0, p1, 
                          type = "pstar"){
  miss <- c(0, 0.1, 0.2, 0.3, 0.4, 0.5)
  target <- result[which(result$method==method &
                           result$Nt==Nt & 
                           result$p0==p0 &
                           result$p1==p1), ]
  res <- data.frame(matrix(NA, nrow = 6, ncol = 6))
  
  for (i in 1:length(miss)){
    for (j in 1:length(miss))
      res[i,j] <- target[which(target$miss0==miss[i] & target$miss1==miss[j]), type]
  }
  rownames(res) <- as.character(miss)
  colnames(res) <- as.character(miss)
  apply(res, 2, my_signif)
}
