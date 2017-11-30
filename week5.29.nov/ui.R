library(shiny)
shinyUI(fluidPage(
  titlePanel(p("Data Science Capstone Project.",style="text-align:center;")),
  sidebarLayout(
    sidebarPanel(
      p("Let's play around. ", style="font-weight:bold; color:blue"),
      p("Please allow a few moment to load the model for the first time."),
      textAreaInput("textArea","Start typing..", value = "", width = NULL, height = NULL, cols = NULL, rows = NULL, placeholder = 'Enter your text..', resize = NULL),
      sliderInput("wordCloud", "How many max. word suggestions you want?", 3, 10,step=1, value=5),
      ##actionButton("predictWord","Predict Word"),
      p("Author:Suman Adhikari"),
      p("Email : dralmostright@gmail.com")
      #radioButtons("radioButtons", "Select Suppliment Type:", c("OJ", "VC"))
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Prediction",
                 mainPanel(
                   h3("Predicted word:"),
                   uiOutput("words"),
                   h3("Your Text:"),
                   verbatimTextOutput("value")
                   ),
                   plotOutput("plot1",height="250px", width="250px")
                 ),
        tabPanel("User Manual",
                 mainPanel(
                   includeMarkdown("about.Rmd"))),
        tabPanel("Documentation",
                 mainPanel(
                   includeMarkdown("ds-capstone-project.rmd")))
      )
    ))
))