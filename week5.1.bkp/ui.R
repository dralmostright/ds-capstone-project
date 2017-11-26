library(shiny)
shinyUI(fluidPage(
  titlePanel(p("Data Science Capstone Project.",style="text-align:center;")),
  p("Around the world, people are spending an increasing amount of time on their 
    mobile devices for email, social networking, banking and a whole range of other 
    activities. But typing on mobile devices can be a serious pain. Hence in this Coursera 
    DataScience Specialization Capstone Project I am motivated to address the problem by 
    starting with analyzing a large corpus of text documents to discover the structure 
    in the data and how words are put together, then sampling and building a predictive 
    text model. In this stage i am combining all models and developing data products 
    using Shiny APP.", style="text-align:justify; border-left: 5px solid lightgrey;
    background-color: #fff; color:#666;
    border-bottom: 5px solid lightgrey; border-radius:5px; padding: 20px 20px 15px 20px"),
  sidebarLayout(
    sidebarPanel(
      p("Let's play around. ", style="font-weight:bold; color:blue"),
      p("Please allow a few moment to load the model for the first time."),
      textAreaInput("textArea","Start typing..", value = "", width = NULL, height = NULL, cols = NULL, rows = NULL, placeholder = 'Enter your text..', resize = NULL),
      sliderInput("wordCloud", "How many word suggestions you want?", 3, 10,step=1, value=5),
      actionButton("predictWord","Predict Word"),
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
                   plotOutput("plot1",height="200px", width="200px")
                 ),
        tabPanel("Documentation",
                 mainPanel(
                   includeMarkdown("about.Rmd")))
      )
    ))
))