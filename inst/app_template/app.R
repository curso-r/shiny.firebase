library(shiny)

ui <- fluidPage(
  titlePanel("It works!"),
  shiny.firebase::firebaseLogoutButton()
)

server <- function(input, output, session) {

}

shiny.firebase::shinyAppFirebase(ui, server)
