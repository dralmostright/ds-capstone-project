## ngramTDM function takes input as corpus and creates ngram Term Document Matrix
## start specifies the starting point for ngarm 
## stop specifies the ending point for ngram
## finally retruns term document matrix from start to stop
ngramTDM <- function(corpus, start=NULL, stop=NULL){
  ## Handling the start and stop values
  if(is.null(start) & is.null(stop)){
    start <- 1
    stop <- 1
  }
  else if (is.null(start) & !is.null(stop)){
    start <- 1
  }
  else if (!is.null(start) & is.null(stop)){
    stop <- start
  }
  else {
	if(stop < start){
		print("Stop value is lesser than start.")
	}
  }
  
  ## Creating tokenizer handle
  ngramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min=start, max=stop))
  
  ## Create term document matrix 
  tdm <- TermDocumentMatrix(corpus, control = list(tokenize = ngramTokenizer))
  return(tdm)
}

##
## Generate Term Frequency matrix for ngram TDM
##

getTermFreq <- function(tdm, threshold=NULL){
	freqTerm <- rowSums(as.matrix(tdm))
	oraIndex <- order(freqTerm, decreasing = TRUE)
	if(is.null(threshold)){
		data <- melt(freqTerm[oraIndex])
	}
	else {
	    data <- melt(head(freqTerm[oraIndex], threshold))
	}
	remove(freqTerm)
	gc()
	data$term <- dimnames(data)[[1]]
	return(data)
}
