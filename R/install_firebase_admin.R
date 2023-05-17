install_firebase_admin <- function(method = c("auto", "virtualenv", "conda"),
         conda = "auto", envname = NULL,
         conda_python_version = "3.9", ...) {

  # Install
  method <- match.arg(method)
  reticulate::py_install(
    packages = "firebase_admin",  envname = envname, method = method,
    conda = conda, python_version = conda_python_version, pip = TRUE, ...)

  # Should probably restart session
  message("Please restart your R session")

  invisible(TRUE)
}

# Environment for globals
firebase_env <- new.env(parent = emptyenv())

# Load python
.onLoad <- function(libname, pkgname) {
  reticulate::configure_environment(pkgname)

  assign(
    "firebaseAdmin",
    reticulate::import("firebase_admin", delay_load = TRUE),
    firebase_env
  )
}
