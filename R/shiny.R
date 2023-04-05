uiFirebase <- function(ui) {
  function(req) {
    token <- try(
      parseCookies(req$HEADERS['cookie'])$firebase_token,
      silent = TRUE
    )
    if (class(a) == "try-error" | is.null(token)) {
      shiny::tags$script(shiny::HTML('location.replace("login/index.html");'))
    } else {
      firebaseAdmin <- init_firebase_admin()
      credentials <- firebaseAdmin$credentials$Certificate("serviceAccountKey.json")
      firebaseAdmin$initialize_app(
        credentials,
        list('databaseURL'= NULL)
      )
      res <- try(firebaseAdmin$auth$verify_id_token(token), silent = TRUE)
      if (class(res) == "try-error") {
        shiny::tags$script(shiny::HTML('location.replace("login/index.html");'))
      } else {
        if (is.function(ui)) {
          ui(req)
        } else {
          ui
        }
      }
    }
  }
}

serverFirebase <- function(server) {
  server
}

shinyAppFirebase <- function(ui, server, ...) {
  shiny::shinyApp(uiFirebase(ui), serverFirebase(server), ...)
}
