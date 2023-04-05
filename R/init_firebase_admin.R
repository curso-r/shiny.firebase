init_firebase_admin <- function() {
  reticulate::use_virtualenv("firebase")
  reticulate::import("firebase_admin")
}
