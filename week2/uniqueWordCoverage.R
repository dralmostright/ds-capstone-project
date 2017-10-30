##
## Function to count unique word count to cover % of corpus
##

calFreqWordInstance <- function(tfm, threshold){
wordFreq <- 0
uniqueCount <- 0
totalWord <- sum(tfm$value)
for(i in 1:nrow(tfm)){
wordFreq <- wordFreq + tfm[i, "value"]
wordCoverage <-  round((wordFreq/totalWord) * 100, 2)
if(wordCoverage >= threshold){
  uniqueCount <- i
  return(uniqueCount)
  break
}
}


##
## Map percentage and wordcount and retrun matrix
##

wordPercent <- seq(10, 90, by=10)

totalTermCount <- sum(uniTFM$value)
wordPerValue <- 0
wordCount <- 0
j <- 1
for(i in 1:nrow(uniTFM)){
wordCount <- wordCount + uniTFM[i, "value"]
wordCoverage <- round((wordCount/totalTermCount) * 100,2)
if (wordCoverage >= wordPercent[j]){
wordPerValue[j] <- i
j <- j+ 1
}
if(j > 9){
break
}
}
