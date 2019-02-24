## Jeff Leath
## This code collects tweets from the Twitter API
## 
## Since the Twitter API (free edition) only goes back 9 days...
## 
## This script exports the file, where I then use with Tableau

# This function pulls tweets that mention the keyword requested.



# load package
library("twitteR")


# variables for consumer_key, consume_secret, access_token, and access_secret
# refernces a local file to secure keys from GitHub

consumer_key <- Sys.getenv("Twitter_consumer_key") 
consumer_secret <- Sys.getenv("Twitter_consumer_secret")
access_token <- Sys.getenv("Twitter_access_token")
access_secret <- Sys.getenv("Twitter_access_secret")

##Connect to API and get Authorization


# Search Twitter
tw = searchTwitter(c('illumina','MiSeq','MiniSeq','NextSeq','NovaSeq','iSeq','HiSeq'), # Key Term to search
                   n = 1e5 , #Max number of records to retrieve
                   geocode = NULL,
                   since = '2019-01-01',
                   retryOnRateLimit = 1e3
)
tweets = twListToDF(tw)

#This writes the tweets in a .csv file

write.table(tweets, file="tweets01.csv",
            sep=",",
            row.names=FALSE,
            quote = TRUE,
            qmethod = c("escape", "double")
)

## This code performs a Sentiment Analysis on a source data file of tweets

str(tweets)
summary(tweets)


# Build corpus
library(tm)
corpus <- iconv(tweets$text, to = "utf-8")
corpus <- Corpus(VectorSource(corpus))
inspect(corpus[1:5])

# Clean text
corpus <- tm_map(corpus, tolower)
inspect(corpus[1:5])

corpus <- tm_map(corpus, removePunctuation)
inspect(corpus[1:5])

corpus <- tm_map(corpus, removeNumbers)
inspect(corpus[1:5])

cleanset <- tm_map(corpus, removeWords, stopwords('english'))
inspect(cleanset[1:5])

removeURL <- function(x) gsub('http[[:alnum:]]*', '', x)
cleanset <- tm_map(cleanset, content_transformer(removeURL))
inspect(cleanset[1:5])

## example to remove specific words
cleanset <- tm_map(cleanset, removeWords, c('illumina','illumina'))

## example to merge/find and replace
cleanset <- tm_map(cleanset, gsub, 
                   pattern = 'stocks', 
                   replacement = 'stock')

cleanset <- tm_map(cleanset, stripWhitespace)
inspect(cleanset[1:5])

# Term document matrix
tdm <- TermDocumentMatrix(cleanset)
tdm
tdm <- as.matrix(tdm)
tdm[1:10, 1:20]


# Bar plot
w <- rowSums(tdm)
w <- subset(w, w>=500)
barplot(w,
        las = 2,
        col = rainbow(50))
# Word cloud
library(wordcloud)
w <- sort(rowSums(tdm), decreasing = TRUE)
set.seed(222)
wordcloud(words = names(w),
          freq = w,
          max.words = 150, #max number of words in the cloud
          random.order = F,
          min.freq = 500, #minimun number of occurances
          colors = brewer.pal(8, 'Dark2'),
          scale = c(2, 0.3),
          rot.per = 0.7)



# Search Twitter, Donald Trump Tweets
dt = searchTwitter('from:realDonaldTrump', # Key Term to search
                   n = 1e5 , #Max number of records to retrieve
                   geocode = NULL,
                   since = '2019-01-01',
                   retryOnRateLimit = 1e3
)
dttweets = twListToDF(dt)
