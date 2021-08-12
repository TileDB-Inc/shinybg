#' @title AppManager
#' @description Manage shiny apps running in background tasks.
#' @export
#' @examples \dontrun{
#' # Make a stub
#' manager <- AppManager$new()
#' manager
#'
#' # Create background shiny apps
#' app <- system.file("apps/sever-info-app.R", package = "shinybg")
#' app1 <- runBackgroundApp(appFile = app, port = 3001)
#' app2 <- runBackgroundApp(appFile = app, port = 3002)
#'
#' # Register the apps
#' manager$register_app(port = 3001, app = app1)
#' manager$register_app(port = 3002, app = app2)
#'
#' # List all managed apps
#' manager
#' manager$list_ports()
#'
#' # Retrieve app by port
#' manager$retrieve_app(port = "3001")
#'
#' # Kill all apps
#' manager$kill_all_apps()
#' }
AppManager <- R6::R6Class(
  "AppManager",
  public = list(
    #' @field apps (list) list of running shiny apps named for their
    apps = list(),

    #' @description print method for the `AppManager` class
    #' @param x self
    #' @param ... ignored
    print = function(x, ...) {
      cat("<shinybg apps> ", sep = "\n")
      if (length(self$apps) == 0) {
        cat("..No managed apps..", sep = "\n")
      } else {
        cat(" Running apps", sep = "\n")
        ports <- names(self$apps)
        for (i in seq_along(self$apps)) {
          cat(ports[[i]], "|", self$apps[[i]]$format())
        }
      }
      invisible(self$apps)
    },

    #' @description Register an app
    #' @param port TCP port the app is listening on (e.g., 3000)
    #' @param [callr::r_process] for a Shiny app
    #' @return nothing returned
    register_app = function(port, app) {
      stopifnot(inherits(app, "r_process"))
      port <- as.character(port)
      if (!is.null(self$apps[[port]])) {
        stop(
          paste("Another process is already registered on port", port),
          call. = FALSE
        )
      }
      self$apps[[port]] <- app
    },

    #' @description Retrieve a registered app
    #' @param port TCP port the app is listening on (e.g., 3000)
    #' @return [callr::r_process] for a Shiny app
    retrieve_app = function(port) {
      port <- private$check_port_exists(port)
      self$apps[[port]]
    },

    #' @description Kill an app's process and deregister it
    #' @param port TCP port the app is listening on (e.g., 3000)
    #' @return `TRUE` if the process was terminated, and `FALSE` if it was not
    kill_app = function(port, verbose = TRUE) {
      port <- private$check_port_exists(port)
      result <- self$apps[[port]]$kill()
      if (result) {
        if (verbose) {
          message(paste("Killed app registered on port", port))
        }
        self$apps[[port]] <- NULL
      }
      result
    },

    #' @description Kill all registered apps
    #' @return Nothing returned
    kill_all_apps = function(verbose = TRUE) {
      killed <- vapply(self$apps, function(x) x$kill(), FUN.VALUE = logical(1L))
      if (verbose) message(sprintf("Successfully killed %i apps", sum(killed)))
    },

    #' @description List ports used by registered apps
    #' @return Character vector with 0 or more elements
    list_ports = function() {
      names(self$apps)
    }
  ),

  private = list(
    check_port_exists = function(port) {
      port <- as.character(port)
      if (!port %in% names(self$apps)) {
        stop(
          paste("No app is registered for port", port),
          call. = FALSE
        )
      }
      port
    }
  )
)
