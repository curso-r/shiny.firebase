library(shiny)
devtools::load_all()

ui <- fluidPage(
  titlePanel("It works!")
)

server <- function(input, output, session) {

}

shinyAppFirebase(ui, server)
