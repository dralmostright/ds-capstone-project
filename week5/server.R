library(shiny)
library("wordcloud")
library("RColorBrewer")
library("stringr")
library("dplyr")


shinyServer(function(input, output, session){
  ##source('/R/workspace/capstoneProject/ds-capstone-project/week2/improvedPrediction.R')
  ##
  ## Loading the computed ngram models
  ##
  datadir <- "/R/workspace/capstoneProject/dataset/final/sample/RData/"

  ngTDM <- grep('*TFM.RData$',dir(datadir), value=T)
  
  for (i in 1: length(ngTDM)){
      varname <- sub(".RData", "",ngTDM[i])
      assign(paste(varname),readRDS(paste0(datadir,ngTDM[i])))
      print(paste0("Loaded: ",ngTDM[i]))
    }
  uniTFM <- uniTFM[,2:1]
  
  ##uniTFM <- uniTFM[1:10,]
  
  ##
  getNextTerm <- function(findTerm, clusterSize){
    
    stringLen <- length(strsplit(findTerm, "\\s+")[[1]])
    
    ##
    ## Whenever sting length is greater then 0 clean text
    ##
    if(stringLen >= 4){
      findTerm <- paste(word(findTerm,-3:-1), collapse=' ')
      stringLen <- 3 
    }
    
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
        predicWord <- head(uniTFM[,],clusterSize)
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
  ##
  
  ## Temporary Matrix to hold the data
  ##predicWord <- getNextTerm('', 5)
  
  
  modelpred <- reactive({
    
    if(input$textArea ==""){
      inputText <- ''
    }
    else {
      inputText <- input$textArea
    }
    
    inputText <- trimws(inputText)
    inputText <- tolower(inputText)
    inputText <- gsub("[[:punct:]]","",inputText)
    inputText <- gsub("[0-9]","",inputText)
    
    inputText
  })
  
  output$words <- renderUI({
    predictCount <- input$wordCloud
    predicWord <- getNextTerm(modelpred(), predictCount)
    
    if(length(predicWord[,1]) >= predictCount) {
      predictCount <- input$wordCloud
    }
    else{
      predictCount <- length(predicWord[,1])
    }
    
    predicWord <<- predicWord[1:predictCount,]
    buttons <- as.list(1:length(predicWord[,1]))
    buttons <- lapply(buttons, function(i) {
        actionButton(paste0(predicWord[i,1],i),paste(predicWord[i,1]))
    }
    )
  })
  
  output$plot1 <- renderPlot({
    predictCount <- input$wordCloud
    testword <- modelpred()
    if(length(predicWord[,1]) >= predictCount) {
      predictCount <- input$wordCloud
    }
    else{
      predictCount <- length(predicWord[,1])
    }
    predicWord <<- predicWord[1:predictCount,]
    wordcloud(predicWord[,1], predicWord[,2], colors=brewer.pal(8, "Dark2"), random.order=FALSE, rot.per=0.5 )
    title(main = "Predicted Word cloud", font.main = 6, col.main = "#26b67c", cex.main = 1.5)}
    
    , height=200, width=200)
  
  
  output$value <- renderText({ modelpred() })
  
  })