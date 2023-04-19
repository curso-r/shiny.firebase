#' Create a Firebase Shiny app object
#'
#' @param ui The ui object of your app.
#' @param server Ther server function of your app.
#' @param ... Additional parameters passed to shiny::shinyApp function.
#'
#' @return An object that represents the app. Printing the object or passing
#' it to runApp() will run the app.
#' @export
#'
shinyAppFirebase <- function(ui, server, ...) {
  shiny::shinyApp(
    ui = uiFirebase(ui),
    server = serverFirebase(server),
    ...
  )
}

uiFirebase <- function(ui) {
  function(req) {
    token <- try(
      parseCookies(req$HEADERS['cookie'])$firebase_token,
      silent = TRUE
    )
    if (methods::is(token, "try-error") | is.null(token)) {
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
      if (methods::is(res, "try-error")) {
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

    appname <- paste0("server", stats::runif(1))
    firebaseAdmin <- init_firebase_admin()
    firebaseAdmin$initialize_app(
      credential = firebaseAdmin$credentials$Certificate("serviceAccountKey.json"),
      options = list('databaseURL'= NULL),
      name = appname
    )

    shiny::observe({
      token <- cookies::get_cookie("firebase_token")
      session$userData$firebase <- firebaseAdmin$auth$verify_id_token(
        token,
        app = firebaseAdmin$get_app(appname)
      )
    })

    shiny::observeEvent(input$._firebaselogout_, {
      firebaseAdmin$auth$revoke_refresh_tokens(
        session$userData$firebase$uid,
        app = firebaseAdmin$get_app(appname)
      )
      firebaseLogout()
    })

    server(input, output, session)

    shiny::onStop(
      function() {
        firebaseAdmin$delete_app(firebaseAdmin$get_app(appname))
      }
    )

  }
}

#' Firebase logout button
#'
#' @param label The contents of the button or link–usually a text label,
#' but you could also use any other HTML, like an image.
#' @param ... Named attributes to be applied to the button or link.
#' @param id An ID for the button. If you only have one logout button in your
#' app, you do not need to explicitly provide an ID. If you have more than one
#' logout button, you need to provide a unique ID to each button. When you
#' create a button with a non-default ID, you must create an observer that
#' listens to a click on this button and logs out of the app with a call to
#' logout.
#'
#' @export
#'
firebaseLogoutButton <- function(label = "Log out", ..., id = "._firebaselogout_") {
  shiny::actionButton(id, label, ...)
}

#' Logout from Firebase
#'
#' @export
#'
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
