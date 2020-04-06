##ggplot2の勉強用
#参考URL:https://kazutan.github.io/fukuokaR11/intro_ggplot2.html

library(tidyverse)

str(iris)
###描画キャンパス(オブジェクト)の用意
# ggplotのキャンバスを作成
# あわせてdataとaesも指定
p_0 <- 
  ggplot(data = iris, mapping = aes(x = Sepal.Length, y = Petal.Length))

# 書き出してみる
p_0

###キャンパスにlayerを“重ねる”
# ggplot2ではレイヤーなどを重ねるのに `+` を使います
p_1 <- 
  p_0 + 
  layer(geom = "point", stat = "identity", position = "identity")
# 描いてみる
p_1

#もう一つlayerを重ねる
# pointのlayerが入ってるp_1に加えます
p_1_2 <- 
  p_1 +
  layer(geom = "line", stat = "identity", position = "identity")
# 描いてみる
p_1_2　　#ggplot2のレイヤー構造

###geom, statの活用
#layer関数はあまり使われない
# 引数名も省略するパターンが多い
p_2 <- 
  ggplot(iris, aes(x = Sepal.Length, y = Petal.Length)) +
  geom_point() +
  geom_line()
p_2
#このgeom_*は、｢geometricに*を指定するときにいい感じに出てくれる設定をまとめてくれて、layer関数に流しこむ｣関数

###グループ化
# aesにcolor = Speciesを追加
p_3 <- 
  ggplot(iris, aes(x = Sepal.Length, y = Petal.Length, color = Species)) +
  geom_point()
# 出力
p_3

# aes内を変更
#連続変量でも可能
p_3_2 <- 
  ggplot(iris, aes(x = Sepal.Length, y = Petal.Length, color = Petal.Width)) +
  geom_point()
p_3_2

#色ではなく形や線種、透明度でグループ化変数を表現できる
# shapeで形になる
# shapeで形になります
p_3_3 <- 
  ggplot(iris, aes(x = Sepal.Length, y = Petal.Length, shape = Species)) + 
  geom_point()
p_3_3

#色と形
p_3_4 <- 
  ggplot(iris, aes(x = Sepal.Length, y = Petal.Length, shape = Species,color = Species)) + 
  geom_point()
p_3_4

###scale:軸周りの設定
# デフォルトを作っておく
p_4_0 <-
  ggplot(iris, aes(x = Sepal.Length, y = Petal.Length, color = Species)) +
  geom_point()

# y軸を0から7までに
p_4_0 + scale_y_continuous(limits = c(0, 7))

###theme:背景色とか目盛線の色
#白黒系テーマを当ててみる
p_4_0 + theme_bw()

###title, labelsなど
p_4_0 +
  labs(title = "タイトルだよー",
       subtitle = "サブタイトルだよー",
       caption =  "図のキャプションだよーだよー",
       x = "えっくすじくだよー",
       y = "わいじくだよー",
       color = "からーだよー")

###facet:｢条件ごとに別々の図にして並べたい｣という場合
# Speciesごとに分けて、行方向にプロット
# vars()で与えればOK
p_4_0 +
  facet_grid(rows = vars(Species))

# 行数や列数を指定する場合はfacet_wrapの方が便利
# 切り分ける変数はformulaで与える
p_4_0 +
  facet_wrap(~Species, nrow = 2)

###coordinate:｢縦軸と横軸を入れ替えたい｣とか｢一部をズームアップしたい｣といった場合
# 横軸と縦軸を入れ替える場合はcoord_flipを当てる
p_4_0 +
  coord_flip()

##ggplot2 gallary

###geom_point:点をプロット。いわゆる散布図
ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width, color = Petal.Length, shape = Species)) +
  geom_point()

#また、geom_smoothと組み合わせて回帰直線の当てはめなどができます:
ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width, color = Species)) +
  geom_point() +
  geom_smooth(method = "lm")


###geom_histgram：ヒストグラムをプロット
ggplot(iris, aes(x = Sepal.Length)) +
  geom_histogram()
# geom_histgramにbin_width引数で区間の幅を、bins引数で区間数を指定できます
ggplot(iris, aes(x = Sepal.Length)) +
  geom_histogram(bins = 10)

# aesにてfillを指定
# barの場合、colorは外枠でfillが塗りつぶしになる
ggplot(iris, aes(x = Sepal.Length, fill = Species)) +
  geom_histogram(bins = 10)

###box plot：箱ひげ図:
ggplot(iris, aes(x = Species, y = Sepal.Length)) +
  geom_boxplot()
#mappping-aesにはxに離散変量、yに連続変量を指定することが必須

#実際のデータがどんな分布をしているかを掴みやすくするため、geom_jitterをよく組み合わせる
ggplot(iris, aes(x = Species, y = Sepal.Length)) +
  geom_boxplot() +
  geom_jitter()

###geom_violin:通称バイオリンプロット
ggplot(iris, aes(x = Species, y = Sepal.Length)) +
  geom_violin()

###geom_bar:棒グラフを描画
#サンプル用にデータを作成
df_1 <- data.frame(
  d1 = sample(letters[1:5], 300, replace = TRUE, prob = c(1, 2, 3, 4, 5)),
  d2 = sample(letters[18:20], 300, replace = TRUE, prob = c(1, 3, 6)),
  d3 = sample(letters[22:23], 300, replace = TRUE, prob = c(3, 7)),
  c1 = rnorm(300, 100, 10),
  c2 = rnorm(300, 150, 20),
  c3 = rnorm(300, 50, 10)
)

# 集計
df_1_agg1 <- df_1 %>% 
  group_by(d1, d2) %>% 
  summarise(mean_c1 = mean(c1),
            se_c1 = sd(c1) / sqrt(n())) %>% 
  ungroup()

# 内容の確認
str(df_1_agg1)

#集計データからプロットするときには、stat = "identity"を利用

# position = "dodge"で横に並べる配置になる
ggplot(df_1_agg1, aes(x = d1, y = mean_c1, fill = d2)) +
  geom_bar(stat = "identity", position = "dodge")



#多くの場合エラーバーを重ねる
#今回はすでにseを算出しているので、これを利用してgeom_errorbarを当てる:
ggplot(df_1_agg1, aes(x = d1, y = mean_c1, fill = d2)) +
  geom_bar(stat = "identity", position = "dodge") +
  geom_errorbar(aes(ymax = mean_c1 + se_c1, ymin = mean_c1 - se_c1),
                width = 0.5, position = position_dodge(width = 0.9))


###geom_tile:ヒートマップ
# geom_barで使ったデータを利用
ggplot(df_1_agg1, aes(x = d1, y = d2, fill = mean_c1)) +
  geom_tile()

#それぞれのタイル上に値を重ねるなら、geom_textを利用
ggplot(df_1_agg1, aes(x = d1, y = d2, fill = mean_c1)) +
  geom_tile() +
  geom_text(aes(label = round(mean_c1, digits = 1)), color = "white")

###ggplot2で描くコツ
#dataとmapping(aes)を意識する
#どんなデータでどんなマッピングをさせるのかが重要
#離散と連速を意識する:多くのミスがここ
#ggplot2では離散型はfactor, charactor, boolean
#データの加工などはggplot内で極力さける
#データ処理プロセスと描画プロセスは分けたほうがわかりやすい
#まずはシンプルなものから作っていく
#いきなりいろいろ重ねるのではなく、一つ重ねては実行して確認:結局こっちのほうが早いことが多い
#いろんなサンプルコードを“写経”する.手を動かさないと無理
