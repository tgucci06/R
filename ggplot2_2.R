##ggplot2勉強用 part2

#参考URL：https://mrunadon.github.io/ggplot2/
library(tidyverse)

#以下　全ggplotに適用(theme_set)するもの
#"グラフタイトル14pt",”日本語表示”
ggplot()+
  theme_set(theme_bw(base_size = 14,base_family="HiraKakuProN-W3"))

##基本グラフ編
###1. 散布図:scatter plot
g1  <- 
  ggplot(iris,
         aes(x = Sepal.Length,
             y = Sepal.Width))
#ggplot（）で作ったキャンバスに、geom_point（）で散布図を上書き(+geom_point()を足す)する。
g1  <- 
  g1 + geom_point(aes(color = Species),
                  size  = 1, #点の大きさ
                  alpha = 0.5)　#透過性0.5

g1

###2.ラインプロット:line plot
#時系列的な線つなぎ
g2  <- 
  ggplot(iris,
         aes(x = Sepal.Length,y = Sepal.Width))

g2  <- 
  g2 + geom_line(aes(colour = Species),size = 0.5)
##線をgeom_line()で足す。x軸とｙ軸はキャンバスの設定時に宣言したので不要

g2  <- 
  g2 + geom_point(aes(colour = Species),
                  size = 1,alpha = 0.5)

g2

###3. 密度関数:density plot
g3  <- 
  ggplot(iris,aes(x = Sepal.Length))　#y軸の宣言は不要

g3  <- 
  g3 + geom_density(aes(fill = Species),
                    size = 0.5,alpha = 0.5)

g3  <- 
  g3 + xlim(3,10) #x軸の範囲を設定

g3

#colour = は線や点の色。fill＝は塗りつぶしの色

#全部同じ色にしたいとき
g3_1  <- 
  ggplot(iris,aes(x = Sepal.Length))　#y軸の宣言は不要

g3_1  <- 
  g3_1 + geom_density(aes(),fill = 'red',
                      size = 0.5,alpha = 0.5)

g3_1  <- 
  g3_1 + xlim(3,10) #x軸の範囲を設定

g3_1

###4.ヒストグラム:histogram
g4  <- 
  ggplot(iris,aes(x = Sepal.Length)) 
#ヒストグラムのy軸は度数なので、ここでは指定不要
g4  <- 
  g4 + geom_histogram(aes(fill = Species),
                      bins = 30, #棒は３０本立てる
                      size = 10,
                      alpha = 0.5)
g4

g4_1  <- 
  ggplot(iris,aes(x = Sepal.Length)) 

g4_1  <- 
  g4_1 + geom_histogram(aes(fill = Species),
                        bins = 30, #棒は３０本立てる
                        binwidth = 0.5, #x軸の値0.5の範囲ずつで度数をまとめる
                        size = 10,
                        alpha = 0.5)
g4_1

###5.ヒストグラムと密度曲線の重ね書き
#ヒストグラムは度数で、密度曲線は確率密度をｙ軸にとるためコツが必要

#キャンバスを用意
g5  <- 
  ggplot(iris,
         aes(x = Sepal.Length,
             y = ..density.., #ｙ軸を確率密度に合わせる
             colour = Species, #線はSpeciesごと
             fill = Species　　#塗り潰しもSpeciesごと
         )
  )
#ヒストグラム
g5  <- 
  g5 + geom_histogram( 
    position = 'identity',
    alpha = 0.5
  )

#密度曲線
g5  <- 
  g5 + geom_density( 
    stat = 'density',
    position = 'identity',
    alpha = 0.5
  )

g5  <- 
  g5 + xlim(3,10) #x軸の範囲

g5

###6.エラーバー
#キャンバスを用意
g6  <- 
  ggplot(iris,
         aes(x = Sepal.Length,
             y = Sepal.Width))

g6  <- 
  g6 + 
  geom_errorbar(aes(ymin = Sepal.Width - 0.7,
                    ymax = Sepal.Width + 0.7),
                colour = 'gray40',
                alpha = 0.1,
                size = 1)
#エラーバーの上に、点を上書き
g6  <- 
  g6 + geom_point(aes(colour = Species),
                  size = 2,
                  alpha = 0.5)

g6

###7.棒グラフ

g7  <- 
  ggplot(iris,
         aes(y = Petal.Length,
             x = Species,
             fill = Species))

#stat_summary():統計処理
g7  <- 
  g7 + stat_summary(fun.y = 'mean',
                    geom = 'bar',
                    alpha = 0.5)

###########################################
#注）データが正規分布であると仮定した歳の標準誤差と信頼区間。
# データが比率である場合などは、これで出してはいけない
###########################################

###stat_summary()を使うためにパッケージインストール##
install.packages("Hmisc") #ブラウザではうまくいかなかった。。。
library(Hmisc)


#標準誤差はmean_cl_normalで計算
#ここでの標準誤差は,上で指定したfill=Speciesの種類ごとに計算される
g7_1  <- 
  g7 + stat_summary(fun.data = mean_cl_normal,
                    geom = 'errorbar',
                    alpha = 0.5,
                    size = 0.3,
                    width = 0.3)
#95%信頼区間をエラーバーにしたい場合はmean_sdl
g7_2  <- 
  g7 + stat_summary(fun.data = mean_sdl,
                    geom = 'errorbar',
                    alpha = 0.5,
                    size = 0.3,
                    width = 0.3)
g7


###8.ヴァイオリンプロット：violin plot
g8  <- 
  ggplot(iris,
         aes(y = Petal.Length,
             x = Species,
             fill = Species))

g8 <- 
  g8 + geom_violin(alpha = 0.5,
                   colour = 'gray')
g8

###9.箱ひげ図:box plot
g9  <- 
  ggplot(iris,
         aes(y = Petal.Length,
             x = Species,
             fill = Species))

g9  <- 
  g9 + geom_boxplot(alpha = 0.5,
                    colour = 'gray30')
g9

##オプション編
###10.グラフとレジェンドタイトル&テキストの変更
#ベースとなる図。g9を使用
g10  <- 
  ggplot(iris,
         aes(y = Petal.Length,
             x = Species,
             fill = Species))
g10  <- 
  g10 + geom_boxplot(alpha = 0.5,
                     colour = 'gray30')

#グラフのタイトルサイズ変更
g10  <- 
  g10 + theme_bw(base_size = 14,
                 base_family = 'HiraKakuProN-W3')

#軸のタイトルサイズ変更
g10  <- 
  g10 + theme(axis.title.x = element_text(size = 14),
              axis.title.y = element_text(size = 14))

#軸のテキストサイズ変更
g10  <- 
  g10 + theme(axis.text.x = element_text(size = 12),
              axis.text.y = element_text(size = 12))

#グラフの右に出るレジェンドのタイトルサイズとその下についている項目のテキストサイズ
g10  <- 
  g10 + theme(legend.title = element_text(size = 14),
              legend.text = element_text(size = 14),
              legend.key = element_rect(colour = 'white'))

#レジェンドのタイトルと項目の内容を変更
g10  <- 
  g10 + labs(fill = 'アヤメの品種')  #colourで分けている場合はcolour = 'アヤメの品種'

g10  <- 
  g10 + scale_fill_hue(name = 'アヤメの品種',
                       labels = c(setosa = 'ヒオウギアヤメ',
                                  versicolor = 'ハナショウブ',
                                  virginica = 'カキツバタ'))

#軸名の変更
g10  <- 
  g10 + ylab('花びらの長さ(Petal.Length)')


g10  <- 
  g10 + xlab('アヤメの品種')

#グラフタイトルの変更
g10  <- 
  g10 + ggtitle('アヤメの品種ごとの花びらの長さ')

g10
#docker上では文字化け

###11.グラフの分割.1
#diamondsデータを使用
g11  <- 
  ggplot(data = diamonds,
         aes(x = price,
             fill = cut))

g11  <- 
  g11 + geom_histogram(alpha = 0.5)

#cutの種類ごとに分割
g11  <- 
  g11 + facet_wrap(~cut)

g11

###12.グラフの分割.2
g12  <- 
  ggplot(data = diamonds,
         aes(x = price,
             fill = cut))

g12  <- 
  g12 + geom_histogram(alpha = 0.5)

#cutの種類ごとに分割,ncol=を指定
g12  <- 
  g12 + facet_wrap(~cut,ncol = 5) #5列に並べる

g12

###13.グラフの分割.3
g13  <- 
  ggplot(data = diamonds,
         aes(x = price,
             fill = cut))

g13  <- 
  g13 + geom_histogram(alpha = 0.5)

#cutの種類ごとに分割,ncol=を指定
g13  <- 
  g13 + facet_wrap(~cut,ncol = 2,nrow = 3) #3行2列に並べる

g13

#14.カラーパレットの変更
#sequential palette　連続グラデーションの例
g14  <- 
  ggplot(diamonds,
         aes(carat,price))+
  geom_point(aes(colour = clarity))

g14  <- 
  g14 + scale_color_brewer(palette = 'BuGn')

g14

##discrete palette　離散塗り分け
g14_1  <- 
  ggplot(diamonds,
         aes(x = carat))

g14_1  <- 
  g14_1 + geom_histogram(aes(fill = cut),alpha = 0.5)

g14_1  <- 
  g14_1 + scale_fill_brewer(palette = 'Spectral')

g14_1

#15.x軸とy軸の入れ替え
g15  <- 
  ggplot(iris,
         aes(y = Petal.Length,
             x = Species,
             fill = Species))

g15  <- 
  g15 + geom_violin(alpha = 0.5,
                    colour = 'gray')

#この１行で転置
g15  <- 
  g15 + coord_flip()
g15

###16.グラフテーマの変更
g16　<-
  ggplot(iris,aes(x=Sepal.Length))

g16　<-
  g16 + geom_density(aes(fill=Species),
                     size=0.5,alpha=0.5)
g16  <-
  g16 + xlim(3,10)

#set theme
g16  <- 
  g16 + theme_bw()

g16  <- 
  g16 + theme_dark()

g16  <- 
  g16 + theme_classic()

###17.線の追加
# horizontal/vertical/Slope lines　平行線、垂直線、斜め線

g17  <- 
  ggplot(iris,
         aes(y = Petal.Length,
             x = Petal.Width))

g17  <- 
  g17 + geom_point(alpha = 0.5,
                   aes(colour = Species))

g17  <- 
  g17 + geom_hline(yintercept = 5, #y=5
                   size = 2,
                   linetype = 2,
                   colour = 'blue')

g17  <- 
  g17 + geom_vline(xintercept = 1.7, #x=1.7
                   size = 1,
                   linetype = 3,
                   colour = 'red')

g17  <- 
  g17 + geom_abline(slope = 1, #傾き
                    intercept = 3,　#切片
                    size = 1,
                    linetype = 4,
                    colour = 'darkgreen')

###18.スムージング,fitting
g18  <- 
  ggplot(iris,
         aes(y = Petal.Length,
             x = Petal.Width))

g18  <- 
  g18 + geom_point(alpha = 0.5,
                   aes(colour = Species))

g18  <- 
  g18 + stat_smooth(method = 'loess',
                    formula = y~x,
                    se = T,
                    fullrange = T,
                    level = 0.95)
g18

###20.回帰直線
#グループごとに回帰直線を引く
g19  <- 
  ggplot(iris,
         aes(y = Petal.Length,
             x = Petal.Width,
             colour = Species))

g19  <- 
  g19 + geom_point(alpha = 0.5)

g19  <- 
  g19 + stat_smooth(method = 'lm',
                    fullrange = T,
                    se = T,
                    aes(fill = Species),
                    alpha = 0.1)
g19
