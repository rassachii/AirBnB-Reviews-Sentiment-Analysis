df <- read.csv("reviews_boston.csv")
library("tidyverse")
library("syuzhet")
library("tm")

mydata <- Corpus(VectorSource(df))
mydata <- tm_map(mydata, content_transformer(tolower))
mydata <- tm_map(mydata, content_transformer(gsub), pattern="\\W",replace=" ")
mydata <- tm_map(mydata, removeNumbers)
mydata <- tm_map(mydata, removePunctuation)
mydata <- tm_map(mydata, stripWhitespace)

result <- get_nrc_sentiment(as.character(mydata))
emotions <- data.frame(colSums(result))

names(emotions)[1] <- "count"
emotions <- cbind("sentiment" = rownames(emotions), emotions)
rownames(emotions) <- NULL

ggplot(emotions, aes(x=sentiment, y=count, fill=sentiment)) +
  geom_bar(stat="identity") + 
  ggtitle("Boston AirBnB Reviews Sentiments")

ggplot(emotions[9:10,], aes(x=sentiment, y=count, fill=sentiment)) +
  geom_bar(stat="identity") +
  ggtitle("Boston AirBnB Reviews Sentiments")
