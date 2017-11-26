##
## Prediction function based on n-gram models
## 
## findTerm : a n-gram text
## clusterSize : no of at most words the model should return.
##
## the function is base on markov chain and backoff model. 
## 
library(stringr)

datadir <- "/R/workspace/capstoneProject/dataset/final/sample/RData/"
  #swtwd(datadir)
ngTDM <- grep('*TFM.RData$',dir(datadir), value=T)
  
  for (i in 1: length(ngTDM)){
      varname <- sub(".RData", "",ngTDM[i])
      assign(paste(varname),readRDS(paste0(datadir,ngTDM[i])))
      print(paste0("Loaded: ",ngTDM[i]))
    }


getNextTerm <- function(findTerm, clusterSize){

stringLen <- length(strsplit(findTerm, "\\s+")[[1]])

##
## Whenever sting length is greater then 0 clean text
##
	if(stringLen >= 4){
		findTerm <- paste(word(findTerm,-3:-1), collapse=' ')
		stringLen <- 3 
		}

#if(stringLen > 0){
#	findTerm <- trimws(findTerm)
#	findTerm <- tolower(findTerm)
#	findTerm <- gsub("[[:punct:]]","",findTerm)
#	findTerm <- gsub("[0-9]","",findTerm)
#}

## looping for backoff
while(stringLen >= 0) {

	## Initialize the prediction vector
		predicWord <- vector()
		
		## Look in 4-gram if given word is 3-gram
			if(stringLen >= 3){
				predicWord <- fourTFM %>% filter(str_detect(term,paste0('^',findTerm,'$'))) %>% select(lastWord,value)
				print(paste0("I am of length:", stringLen))
			}
			
		## Look in 3-gram if given word is 2-gram
			else if (stringLen >= 2){
				predicWord <- triTFM %>% filter(str_detect(term,paste0('^',findTerm,'$'))) %>% select(lastWord,value)
				print(paste0("I am of length:", stringLen))
			}
			
		## Look in 2-gram if given word is 1-gram
			else if (stringLen >= 1){
				predicWord <- biTFM %>% filter(str_detect(term,paste0('^',findTerm,'$'))) %>% select(lastWord,value)
				print(paste0("I am of length:", stringLen))
			}
			
		## if no match found on any n-gram model randomly select 5 words from uniGram
			else{
				predicWord <- head(uniTFM[,2:1],5)
				print("I am of length:0")
				break
			}
		
		## predicted words are 0 then back-off
			if(length(predicWord$lastWord) < 1){
				## Decrease the string length 
				stringLen <- stringLen - 1	
				
				## Truncate the first term
				findTerm <- sub(".*? (.+)", "\\1",findTerm)
			}
			else{
				if(length(predicWord$lastWord) > 5){
				predicWord <- head(predicWord,clusterSize)
				break
				}
				
				## retrun the toatl matched if less than 5 also
				else{
				break
				}
			}
	}	
	## Finally return the words.
	return(predicWord)	
}
