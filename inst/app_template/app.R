library(shiny)

ui <- fluidPage(
  titlePanel("It works!")
)

server <- function(input, output, session) {

}

shiny.firebase::shinyAppFirebase(ui, server)
