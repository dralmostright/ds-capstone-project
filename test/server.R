library(shiny)
library(shinydashboard)

server <- function(input, output, session) {
  output$menuitem <- renderMenu({
    menuItem("Menu item", icon = icon("calendar"))
  })
  
  # to store observers and make sure only once is created per button
  obsList <- list()
  
  output$go_buttons <- renderUI({
    buttons <- as.list(1:input$go_btns_quant)
    buttons <- lapply(buttons, function(i)
    {
      btName <- paste0("go_btn",i)
      # creates an observer only if it doesn't already exists
      if (is.null(obsList[[btName]])) {
        # make sure to use <<- to update global variable obsList
        obsList[[btName]] <<- observeEvent(input[[btName]], {
          cat("Button ", i, "\n")
          output$plot <-renderPlot({hist(rnorm(100, 4, 1),breaks = 50*i)})
        })
      }
      fluidRow(
        actionButton(btName,paste("Go",i))
      )
    }
    )
  })
  
}