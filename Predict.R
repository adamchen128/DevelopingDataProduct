SingleQuotes <- function(InputWord) {
    InputWord <- gsub("'re", " are", InputWord)
    InputWord <- gsub("'ve", " have", InputWord)
    InputWord <- gsub("'m", " am", InputWord)
    InputWord <- gsub("it's", "it is", InputWord)
    InputWord <- gsub("won't", "will not", InputWord)
    InputWord <- gsub("can't", "can not", InputWord)
    InputWord <- gsub("n't", " not", InputWord)
    InputWord <- gsub("'ll", " will", InputWord)
    return(InputWord)
}

toSpace <- content_transformer(function(x, pattern) gsub(pattern, " ", x))
removeSpecial <- content_transformer(function(x) iconv(x, "ASCII", "UTF-8", sub = ""))

MakeCorpus <- function(texts) {
    texts <- SingleQuotes(texts)
    filtered <- VCorpus(VectorSource(texts))
    filtered <- tm_map(filtered, removeNumbers)
    filtered <- tm_map(filtered, toSpace, "/|@|\\|")
    filtered <- tm_map(filtered, removeSpecial)
    filtered <- tm_map(filtered, content_transformer(tolower))
    filtered <- tm_map(filtered, removePunctuation, preserve_intra_word_dashes = TRUE)
    filtered <- tm_map(filtered, stripWhitespace)
}

wordCount <- function(text) { length(unlist(strsplit(text, " "))) }
lastWords <- function(text, n) { paste(tail(unlist(strsplit(text, " ")), n), collapse = " ") }
  
# Match n-gram based on frequencies
MatchNextWord <- function(words, nf, count) {
    nf.size <- length(unlist(strsplit(as.character(nf$word[1]), " ")))
    words.pre <- lastWords(words, nf.size - 1)
    f <- head(nf[grep(paste("^", words.pre, " ", sep = ""), nf$word), ], count)
    r <- gsub(paste("^", words.pre, " ", sep = ""), "", as.character(f$word))
    r[!r %in% c("s", "<", ">", ":", "-", "o", "j", "c", "m")]
}
  
# Predict next word, first try guadgram, then trigram, bigram and unigram
predictNextWord <- function(text, nfl, count) {
    WordNunber <- wordCount(text)
    prediction <- NULL
    if(WordNunber > 4) prediction <- MatchNextWord(text, nfl$f6, count)
    if(length(prediction)) return(prediction)
    if(WordNunber > 3) prediction <- MatchNextWord(text, nfl$f5, count)
    if(length(prediction)) return(prediction)
    if(WordNunber > 2) prediction <- MatchNextWord(text, nfl$f4, count)
    if(length(prediction)) return(prediction)
    if(WordNunber > 1) prediction <- MatchNextWord(text, nfl$f3, count)
    if(length(prediction)) return(prediction)
    prediction <- MatchNextWord(text, nfl$f2, count)
    if(length(prediction)) return(prediction)
    as.character(sample(head(nfl$f1$word, 30), count))
}

# Predict current word
CurrentWordPrediction <- function(text, nfl, count) {
    current <- as.character(MakeCorpus(lastWords(text, 1))[[1]])
    nf <- nfl$f1
    f <- head(nf[grep(paste("^", current, sep = ""), nf$word), ], count)
    as.character(head(f$word, count))
}

# Predict next word
NextWordPrediction <- function(text, nfl, count) {
  text <- as.character(MakeCorpus(text)[[1]], remove.punct=TRUE)
  predictNextWord(text, nfl, count)
}
