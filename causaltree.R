#参考URL:https://saltcooky.hatenablog.com/entry/2020/01/17/021448

#Causal Tree使ってみた
#パッケージインストール
#githubから取得するためのパッケージ
#install.packages("devtools")

#install.packages("Matching")

library(devtools)
library(dplyr)
library(causalTree)
library(Matching)
devtools::install_github("susanathey/causalTree")
dataSet = read.csv("http://biostat.mc.vanderbilt.edu/wiki/pub/Main/DataSets/rhc.csv")
head(dataSet)
table(dataSet[,c("swang1", "death")])
#集計に基づく処置効果は5%程度のようです。
1486/(698+1486) - 2236/(1315+2236)

CT_df <- dataSet %>% 
  dplyr::select(death , swang1, age , sex , race , edu , income , ninsclas , cat1 , das2d3pc , dnr1 , ca , surv2md1 , aps1 , scoma1 , wtkilo1 , temp1 , meanbp1 , resp1 , hrt1 , pafi1 , paco21 , ph1 , wblc1 , hema1 , sod1 , pot1 , crea1 , bili1 , alb1 , resp , card , neuro , gastr , renal , meta , hema , seps , trauma , ortho , cardiohx , chfhx , dementhx , psychhx , chrpulhx , renalhx , liverhx , gibledhx , malighx , immunhx , transhx , amihx) %>% 
  mutate(death = if_else(death=="Yes",1,0),
         swang1 = if_else(swang1=="No RHC",0,1))

#傾向スコアマッチングで平均処置効果を算出したいと思います
PS_model   <-  glm(swang1 ~ .,
                   family = binomial(link = "logit"), 
                   data = CT_df %>% dplyr::select(-death))

PSMatching <- Match(Y = as.integer(CT_df$death)-1, 
                    Tr = (CT_df$swang1==1),
                    X = PS_model$fitted.values,
                    M = 1,
                    caliper = 0.1,
                    ties = FALSE,
                    replace = FALSE)
summary(PSMatching)

#平均処置効果は6.3%と単純な集計で得られる値よりも大きくなっています。

#それではCausal treeを作成
#データの6割を学習データ、4割を予測対象のデータとしました。
CT_df.tr <- CT_df %>% 
  sample_frac(0.6)
CT_df.te <- anti_join(CT_df,CT_df.tr)

#causaltree関数において、splitとCVにHonest型の最適化を行うのかadaptive型の最適化を行うのか設定できます。 それぞれ、split.Honest、cv.Honest引数で設定
causal_tree <- causalTree(death ~ .,
                          data = CT_df.tr %>% dplyr::select(-swang1), 
                          treatment = CT_df.tr$swang1,
                          split.Rule = "CT", 
                          cv.option = "CT", 
                          split.Honest = T, 
                          cv.Honest = T, 
                          split.Bucket = F, 
                          xval = 5, 
                          cp = 0, 
                          minsize = 30)

opcp <- causal_tree$cptable[,1][which.min(causal_tree$cptable[,4])]

causal_tree_pruned <- prune(causal_tree, opcp)
#得られた木構造を見てみます。
rpart.plot(causal_tree_pruned, roundint=FALSE)
#わかりにくいですが、一部のデータではCATEが30%

#得られたCausal Treeを用いてテストデータにおけるCATEを予測させてみる
est_treat <- predict(causal_tree_pruned, CT_df.te)

hist(est_treat)
#平均処置効果をみてみると概ね傾向スコアマッチングの時と同じような値となりました
mean(est_treat)
