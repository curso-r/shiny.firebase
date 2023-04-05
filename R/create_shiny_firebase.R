#' Create shiny firebase app
#'
#' @param path
#' @param overwrite
#'
#' @export
#'
create_shiny_firebase <- function(path, overwrite = FALSE) {
  path <- normalizePath(path, mustWork = FALSE)
  from <- system.file("app_template/", package = "shiny.firebase")
  files_to_copy <- list.files(from, full.names = TRUE)
  file.copy(files_to_copy, to = path, overwrite = overwrite, recursive = TRUE)
}
