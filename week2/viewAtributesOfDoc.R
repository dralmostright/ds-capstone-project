##
## Function to view attributes of the data 
##

fileInfo <- function(inputFile,directory) {
## Set the working directory
setwd(directory)
## Get the size of the file in MB
fSize <- file.info(inputFile)[1]/(1024*1024)
## Open file for reading in text mode
conn <- file(inputFile, open="r")
## Read the lines in memory
lines <- readLines(conn)
## Calculate the total human readable charactes
nChars <- lapply(lines, nchar)
## Get the maximum value for nChars
maxChars <- nChars[which.max(nChars)][[1]]
## Get the Total words for the file
nWords <- sum(sapply(strsplit(lines, "\\s+"),length))
## Close connection
close(conn)
## Retrun the summary
return(c(inputFile, round(fSize,2), length(lines), maxChars, nWords))
}


rawCorpusSummary <- function(directory){
fList <- list.files(directory)
summaryInfo <- lapply(fList,fileInfo,directory=directory)
summaryInfo <- data.frame(matrix(unlist(summaryInfo),length(fList), byrow=T))
colnames(summaryInfo) <- c("File.Name", "Size.MB", "Total.Lines", "Max.Line.Length", "No.Words")
summaryInfo
}
