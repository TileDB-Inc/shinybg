#' List background Shiny applications
#' @return a list of [`callr::r_process`] objects named for the port the Shiny
#'    app is listening on.
#' @family app management functions
#' @export
list_apps <- function() {
    app_manager$apps
}

#' Retrieve a background Shiny application
#' @param port TCP port the app is listening on (e.g., 3000)
#' @family app management functions
#' @export
get_app <- function(port) {
  app_manager$retrieve_app(port)
}

#' Kill a background Shiny application
#' @inheritParams get_app
#' @family app management functions
#' @export
kill_app <- function(port) {
  app_manager$kill_app(port)
}

#' Kill all background Shiny applications
#' @family app management functions
#' @export
kill_all_apps <- function() {
  app_manager$kill_all_apps()
}

#' View background Shiny application
#'
#' Open an application in an external browser or within the configured RStudio
#' viewer
#'
#' @inheritParams get_app
#' @return (Invisibly) The application's URL.
#' @family app management functions
#' @export
view_app <- function(port) {
  app_manager$view_app(port)
}
