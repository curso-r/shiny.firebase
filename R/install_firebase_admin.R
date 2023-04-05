install_firebase_admin <- function() {
  reticulate::py_install(
    packages = "firebase_admin",
    envname = reticulate::virtualenv_create(envname = "firebase"),
    pip = TRUE
  )
}
