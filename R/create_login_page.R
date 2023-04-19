#' Create login page
#'
#' Create a default login page.
#'
#' @param app_path Path of your shiny app file.
#' @param yaml_path Path to your firebase.yaml file.
#' @param overwrite Logical. Overwrite files if they exist. Defaults to FALSE.
#'
#' @return Invisible TRUE.
#' @export
#'
create_login_page <- function(app_path = ".", yaml_file = "./firebase.yaml",
                              overwrite = FALSE) {
  app_path <- normalizePath(app_path, mustWork = FALSE)
  from <- system.file("login_template/", package = "shiny.firebase")
  files_to_copy <- list.files(from, full.names = TRUE)
  if (any(file.exists(files_to_copy))) {
    if (!overwrite) {
      stop("login page exists and overwrite = FALSE")
    }
  }
  file.copy(
    files_to_copy,
    to = paste0(app_path, "/www/"),
    overwrite = TRUE,
    recursive = TRUE
  )
  files_to_modify <- paste0(
    app_path,
    "/www/login/",
    c("login.js", "initFirebaseApp.js")
  )
  envir <- as.environment(yaml::read_yaml(yaml_file))
  purrr::walk(files_to_modify, ~ modify_file(.x, envir))
  invisible(TRUE)
}

