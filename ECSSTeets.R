require(devtools)
install_github("lchiffon/wordcloud2")
library(wordcloud2)
install.packages("twitteR")
library(twitteR)
install.packages("tm")
library(tm)
install.packages("wordcloud")
library(wordcloud)


consumer_key <- "im7uqJJQrcH58GH9McQQTFWeg"
consumer_secret <-"dZyOVcqtH3BEEez19L2H3tetEsgigmkaOUb6YXWNSurXOKwt3a" 
access_token <- "2863118026-Q3QCaM3cT1sNTZ07rTWrk2iSeY07z05kzX31fXg"
access_secret <- "OSurDmFRvYGbxOmLoqm8p5cROog8D9D2eX7oFRQxmzEmA"
setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)


x <- searchTwitter("ECSS2017"  , n = 10000, since = "2017-07-05")
mach_text = sapply(x, function(x) x$getText())

# create a corpus
mach_corpus = Corpus(VectorSource(mach_text))

# create document term matrix applying some transformations
tdm = TermDocumentMatrix(mach_corpus,
   control = list(removePunctuation = TRUE,
   removeNumbers = TRUE, tolower = FALSE,stopwords = TRUE ))
# define tdm as matrix
m = as.matrix(tdm)
# get word counts in decreasing order
word_freqs = sort(rowSums(m), decreasing=TRUE) 
# create a data frame with words and their frequencies
dm = data.frame(word=names(word_freqs), freq=word_freqs)
dm[1:30,]
dm <-subset(dm, freq < 1000) 
raus <- c("presenting", "amp", "eccs", "presentation", "..." , "work","talk", "great", "ecss","see", "sleep", "ECSS..."  )
dm.clean <- dm[!dm$word %in% raus,]
dm.clean <- dm.clean[-2,]

blau <- rgb(34, 58, 96, maxColorValue = 250)
gruen <- rgb(162, 189, 54, maxColorValue = 250)
braun <- rgb(147, 83, 37, maxColorValue = 250)
lila <- rgb(147, 56, 191, maxColorValue = 250)
rot <- rgb(114, 38, 28, maxColorValue = 250)
colorVec = rep(c( blau, gruen, braun, lila), length.out=nrow(demoFreq))
greyy <- rgb(221,221,221, maxColorValue = 250)
my_graph <- wordcloud2(dm.clean, shape = "cardioid", color = colorVec, backgroundColor = greyy )



ECSS <- getUser("@ECSS2017")
location(ECSS)
ECSS$getFollowersCount() # 800


#install webshot
install.packages("webshot")

library(webshot)
webshot::install_phantomjs()

# save it in html
library("htmlwidgets")
saveWidget(my_graph,"tmp.html",selfcontained = F)

# and in pdf
webshot("tmp.html","fig_1.pdf", delay =5, vwidth = 2880, vheight=1280)
