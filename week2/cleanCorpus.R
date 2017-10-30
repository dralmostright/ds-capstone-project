##
## Functions to clean the corpus.
##

##
## Change the case to lower
##

toLower <- function(corpus){
  corpus <- tm_map(corpus,content_transformer(tolower))
  return(corpus)
}

##
## Handle contractions.
##

mapFun <- content_transformer(function(x, src, dest) {return (gsub(src, dest, x))})
completeCase <- function(inputCorpus){
  inputCorpus <- tm_map(inputCorpus, mapFun, src="'ll", dest=" will")
  inputCorpus <- tm_map(inputCorpus, mapFun, src="can't", dest="cannot")
  inputCorpus <- tm_map(inputCorpus, mapFun, src="won't", dest="will not")
  inputCorpus <- tm_map(inputCorpus, mapFun, src="'ve", dest=" have")
  inputCorpus <- tm_map(inputCorpus, mapFun, src="n't", dest=" not")
  inputCorpus <- tm_map(inputCorpus, mapFun, src="'m", dest=" am")
  inputCorpus <- tm_map(inputCorpus, mapFun, src="`m", dest=" am")
  inputCorpus <- tm_map(inputCorpus, mapFun, src="'d", dest=" had")
  inputCorpus <- tm_map(inputCorpus, mapFun, src="'s", dest=" is")
  inputCorpus <- tm_map(inputCorpus, mapFun, src="'re", dest=" are");
  return (inputCorpus)
}
