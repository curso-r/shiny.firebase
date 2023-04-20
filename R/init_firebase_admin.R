init_firebase_admin <- function() {
  if (!reticulate::virtualenv_exists("firebase") |
      !"firebase-admin" %in% reticulate::py_list_packages("firebase")$package) {
    stop("The Python package 'firebase_admin' is not installed.\n
         Please run 'install_firebase_admin()' before running the application.")
  } else {
    reticulate::use_virtualenv("firebase")
    reticulate::import("firebase_admin")
  }
}
