library(shiny)
library("wordcloud")
library("RColorBrewer")
library("stringr")
library(dplyr)


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
  
  uniTFM <- uniTFM[1:10,]
  
  ## Temporary Matrix to hold the data
  predicWord <-  NA
  
  
  modelpred <- reactive({
    predictCount <- input$wordCloud
    
    if(input$textArea ==""){
      inputText <- ' '
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
  
  cat(str(ls()))
  #predWord <<- getNextTerm(modelpred(), 5)
  # to store observers and make sure only once is created per button
  obsList <- list()
  #output$words <- renderUI({
  
  
  output$words <- renderUI({
    buttons <- as.list(1:input$wordCloud)
    
    ###
    valueT <- modelpred()
    findTerm <- valueT
    ##
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
      ## predicWord <- predWord
      
      ## Look in 4-gram if given word is 3-gram
      if(stringLen >= 3){
        predicWord <<- fourTFM %>% filter(str_detect(term,paste0('^',findTerm,'$'))) %>% select(lastWord,value)
        cat(paste0("I am of length:", stringLen))
      }
      
      ## Look in 3-gram if given word is 2-gram
      else if (stringLen >= 2){
        predicWord <<- triTFM %>% filter(str_detect(term,paste0('^',findTerm,'$'))) %>% select(lastWord,value)
        cat(paste0("I am of length:", stringLen))
      }
      
      ## Look in 2-gram if given word is 1-gram
      else if (stringLen >= 1){
        predicWord <<- biTFM %>% filter(str_detect(term,paste0('^',findTerm,'$'))) %>% select(lastWord,value)
        cat(paste0("I am of length:", stringLen))
      }
      
      ## if no match found on any n-gram model randomly select 5 words from uniGram
      else{
        predicWord <<- head(uniTFM[,2:1],input$wordCloud)
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
          predicWord <<- head(predicWord,input$wordCloud)
          break
        }
        
        ## retrun the toatl matched if less than 5 also
        else{
          break
        }
      }
    }	
    ###
    
    buttons <- lapply(buttons, function(i)
    {
      
      btName <- paste0(predicWord[i,2],i)
      
      # creates an observer only if it doesn't already exists
      if (is.null(obsList[[btName]])) {
        # make sure to use <<- to update global variable obsList
        obsList[[btName]] <<- observeEvent(input[[btName]], {
          cat("Button ", i, "\n")
          valueT <- modelpred()
          findTerm <- valueT
          #predWord <<- getNextTerm(valueT, input$wordCloud)
          #output$value <- renderText(paste(valueT ,uniTFM[i,2]))
          updateTextAreaInput(session, "textArea", value = paste(valueT, uniTFM[i,2]))
        })
      }
        actionButton(btName,paste(uniTFM[i,2]))
    }
    )
  })
  
  output$value <- renderText({ modelpred() })
  
  observeEvent(input$textArea, {
  ####
    output$words <- renderUI({
      buttons <- as.list(1:input$wordCloud)
      
      ###
      valueT <- modelpred()
      findTerm <- valueT
      ##
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
        ## predicWord <- predWord
        
        ## Look in 4-gram if given word is 3-gram
        if(stringLen >= 3){
          predicWord <<- fourTFM %>% filter(str_detect(term,paste0('^',findTerm,'$'))) %>% select(lastWord,value)
          cat(paste0("I am of length:", stringLen))
        }
        
        ## Look in 3-gram if given word is 2-gram
        else if (stringLen >= 2){
          predicWord <<- triTFM %>% filter(str_detect(term,paste0('^',findTerm,'$'))) %>% select(lastWord,value)
          cat(paste0("I am of length:", stringLen))
        }
        
        ## Look in 2-gram if given word is 1-gram
        else if (stringLen >= 1){
          predicWord <<- biTFM %>% filter(str_detect(term,paste0('^',findTerm,'$'))) %>% select(lastWord,value)
          cat(paste0("I am of length:", stringLen))
        }
        
        ## if no match found on any n-gram model randomly select 5 words from uniGram
        else{
          predicWord <<- head(uniTFM[,2:1],input$wordCloud)
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
            predicWord <<- head(predicWord,input$wordCloud)
            break
          }
          
          ## retrun the toatl matched if less than 5 also
          else{
            break
          }
        }
      }	
      ###
      
      buttons <- lapply(buttons, function(i)
      {
        
        btName <- paste0(predicWord[i,2],i)
        
        # creates an observer only if it doesn't already exists
        if (is.null(obsList[[btName]])) {
          # make sure to use <<- to update global variable obsList
          obsList[[btName]] <<- observeEvent(input[[btName]], {
            cat("Button ", i, "\n")
            valueT <- modelpred()
            findTerm <- valueT
            #predWord <<- getNextTerm(valueT, input$wordCloud)
            #output$value <- renderText(paste(valueT ,uniTFM[i,2]))
            updateTextAreaInput(session, "textArea", value = paste(valueT, uniTFM[i,2]))
          })
        }
        actionButton(btName,paste(uniTFM[i,2]))
      }
      )
    })
  ###
    
    
  })
  
  
  output$plot1 <- renderPlot({
    predictCount <- input$wordCloud
    uniTFM <- uniTFM[1:predictCount,]
    wordcloud(uniTFM$term, uniTFM$value, colors=brewer.pal(8, "Dark2"), random.order=FALSE, rot.per=0.5 )
    title(main = "Predicted Word cloud", font.main = 6, col.main = "#26b67c", cex.main = 1.5)}, height=200, width=200)
  })