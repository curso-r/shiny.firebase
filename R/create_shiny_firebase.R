#' Create shiny firebase app
#'
#' @param path Path where the app file will be created.
#' @param overwrite Logical. Overwrite files if they exist. Defaults to FALSE.
#'
#' @export
#'
create_shiny_firebase <- function(path, overwrite = FALSE) {
  path <- normalizePath(path, mustWork = FALSE)
  from <- system.file("app_template/", package = "shiny.firebase")
  files_to_copy <- list.files(from, full.names = TRUE)
  file.copy(files_to_copy, to = path, overwrite = overwrite, recursive = TRUE)
  invisible(TRUE)
}
