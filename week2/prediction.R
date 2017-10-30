##
## Prediction algorith using backoff and Markov Chain
##

getNextTerm <- function(findTerm){
stringLen <- length(strsplit(findTerm, "\\s+")[[1]])
if(stringLen >= 3){
predicWord <- fourTFM %>% filter(grepl(findTerm, term)) %>% select(lastWord)
print(paste0("I am of length:", stringLen))
}
else if (stringLen >= 2){
predicWord <- triTFM %>% filter(grepl(findTerm, term)) %>% select(lastWord)
}
else {
print(paste0("I am of length:", stringLen))
}
if(length(predicWord$lastWord) > 3){
predicWord <- sample(predicWord$lastWord,3)
}
return(predicWord)
}
