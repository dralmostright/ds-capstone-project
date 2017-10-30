##
## Function to Get the sample.
##

## selectSample take the document checks its total line size & select the sample based on no of lines
## Set the seed for reproducibility
set.seed(545)
## Function to get the sample lines from docs
selectSample <- function(file, sampleSize, samplePath){
## Open file for reading in text mode
conn <- file(file, open="r")
## Read the lines in memory
lines <- readLines(conn)
## Get no of lines for the file 
fileLength <- length(lines)
## Get the sample lines size based on the total lines on file
sampleSize <- round((sampleSize/100) * fileLength)
## Get the random Indexes
randIndex <- sample(1:fileLength, sampleSize, replace=TRUE)
## Select the lines corresponding to random index
sampleFile <- lines[randIndex]

## Prepare the sampleFile to write back to disk
## Get the name of File
samFileName <- paste0(samplePath, tail(strsplit(file,"/")[[1]],1))
# Check sample file path
sampleTemPath <- gsub("sam_","", samplePath)

# If directory exits check also if file exits & If file exits remove the file
if(dir.exists(sampleTemPath)){
	if(file.exists(samFileName)){
	file.remove(samFileName)
	}
}
# Create the sample path directory
else {
	dir.create(sampleTemPath, showWarnings = TRUE, recursive = TRUE, mode = "0775")
}

# Prepare connection
samFileConn <- file(samFileName, "w+")
# write to disk
writeLines(sampleFile, samFileConn)

## Close all file connection
close(samFileConn)
close(conn)
}

##
## Function to get sample docs
##

makeSample <- function(directory,samplePath){

# Get the list of the files 
fList <- list.files(directory, full.names = TRUE)

# Select the files from the directory, get sample size and save to disk 
samlist <- lapply(fList, selectSample, sampleSize=5,samplePath=samplePath)
print("Sample docs are processed and wrote to disk.")
}
