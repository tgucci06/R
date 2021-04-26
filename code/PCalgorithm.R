## ドキュメントのコード (https://cran.r-project.org/web/packages/pcalg/pcalg.pdf)

## Using Gaussian Data####
# install.packages('pcalg')
# if(!requireNamespace("BiocManager", quietly = TRUE))
# install.packages("BiocManager") 
# BiocManager::install("graph") 

library(pcalg)
data(gmG)
n <- nrow(gmG$x)
V <- colnames(gmG8$x) 
# labels aka node names#

## estimate Skeleton
skel.fit <- skeleton(suffStat = list(C = cor(gmG8$x), n = n),
                     indepTest = gaussCItest, ## (partial correlations)
                     alpha = 0.01, labels = V, verbose = TRUE)
if (require(Rgraphviz)) {
  ## show estimated Skeleton
  par(mfrow=c(1,2))
  plot(skel.fit, main = "Estimated Skeleton")
  plot(gmG8$g, main = "True DAG")
}

# estimate CPDAG
pc.fit <- pc(suffStat = list(C = cor(gmG8$x), n = n),indepTest = gaussCItest, ## indep.test: partial correlations
             alpha=0.01, labels = V, 
             verbose = TRUE)
stopifnot(require(Rgraphviz))
## show estimated CPDAG
if (require(Rgraphviz)) {
  ## show estimated Skeleton
  par(mfrow=c(1,2))
  plot(pc.fit, main = "Estimated DAG")
  plot(gmG8$g, main = "True DAG")
}

