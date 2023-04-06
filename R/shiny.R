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
        credential = credentials,
        options = list('databaseURL'= NULL),
        name = "ui"
      )
      res <- try(
        firebaseAdmin$auth$verify_id_token(
          token,
          app = firebaseAdmin$get_app("ui"),
          check_revoked = TRUE
        ),
        silent = TRUE
      )
      firebaseAdmin$delete_app(firebaseAdmin$get_app("ui"))
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
  function(input, output, session) {

    appname <- paste0("server", runif(1))
    firebaseAdmin <- init_firebase_admin()
    firebaseAdmin$initialize_app(
      credential = firebaseAdmin$credentials$Certificate("serviceAccountKey.json"),
      options = list('databaseURL'= NULL),
      name = appname
    )

    observe({
      token <- cookies::get_cookie("firebase_token")
      session$userData$firebase <- firebaseAdmin$auth$verify_id_token(
        token,
        app = firebaseAdmin$get_app(appname)
      )
    })

    observeEvent(input$._firebaselogout_, {
      firebaseAdmin$auth$revoke_refresh_tokens(
        session$userData$firebase$uid,
        app = firebaseAdmin$get_app(appname)
      )
      firebaseLogout()
    })

    server(input, output, session)

    onStop(
      function() {
        firebaseAdmin$delete_app(firebaseAdmin$get_app(appname))
      }
    )

  }
}

shinyAppFirebase <- function(ui, server, ...) {
  shiny::shinyApp(
    ui = uiFirebase(ui),
    server = serverFirebase(server),
    ...
  )
}

firebaseLogoutButton <- function(label = "Log out", ..., id = "._firebaselogout_") {
  shiny::actionButton(id, label, ...)
}

firebaseLogout <- function() {
  shiny::insertUI(
    selector = "head",
    where = "beforeEnd",
    immediate = TRUE,
    ui = shinyjs::useShinyjs()
  )
  js <- 'location.replace("login/index.html");'
  shinyjs::runjs(js)
}
