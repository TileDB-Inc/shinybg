app_manager <- NULL

.onLoad <- function(libname, pkgname) {
  # initialize empty app manager on package load
  app_manager <<- AppManager$new()
}
