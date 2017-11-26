### Save the computed computation 
saveToFile <- function(data, directory, fileName=NULL){
if(is.null(fileName)){
	fileName <- paste0(deparse(substitute(data)), ".RData")
}

if(!dir.exists(directory)){
	print(paste0("Directory ",directory," does not exists."))
	stopifnot(FALSE)
}
saveRDS(data, paste0(directory, fileName))
print(paste0("Data : ", deparse(substitute(data)), " saved in : ",directory," with filename : ", fileName))
}

### Save the TDM
directory <- "/R/workspace/capstoneProject/dataset/final/RData/2perecnt/"
saveToFile(corpus.uniTDM, directory)
saveToFile(corpus.biTDM, directory)
saveToFile(corpus.triTDM, directory)
saveToFile(corpus.fourTDM, directory)


### Save the TFM
saveToFile(uniTFM, directory)
saveToFile(triTFM, directory)
saveToFile(fourTFM, directory)
saveToFile(biTFM, directory)
