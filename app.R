devtools::load_all()
install_firebase_admin()

ui <- fluidPage(
  titlePanel("It works!"),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        "xvar",
        "X axis",
        choices = names(mtcars)
      ),
      firebaseLogoutButton()
    ),
    mainPanel(
      plotOutput("plot")
    )
  )
)

server <- function(input, output, session) {
  output$plot <- renderPlot({
    plot(x = mtcars[[input$xvar]], y = mtcars$mpg)
  })
}

shinyAppFirebase(ui, server)
