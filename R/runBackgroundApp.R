#' Run Shiny App in a Background Process
#'
#' @param ui The UI definition of the app.
#' @param port The TCP port that the application should listen on (defaults to 3000).
#' @param env Named character vector of environment variables to be passed
#' @inheritParams shiny::runApp
#' @inheritParams shiny::shinyApp
#' @inheritParams callr::r_bg
#' @importFrom IRdisplay display_html
#' @return A [callr::r_process] object for the background Shiny app
#' @examples
#' \dontrun{
#' app <- system.file("apps/sever-info-app.R", package = "shinybg")
#' bg_app <- runBackgroundApp(appFile = app, port = 3005, env = Sys.getenv()["USER"])
#' bg_app$kill()
#' }
#' @import shiny
#' @importFrom callr r_bg
#' @export

runBackgroundApp <- function(
  ui = NULL,
  server = NULL,
  appFile = NULL,
  appDir = NULL,
  port = getOption("shiny.port"),
  host = getOption("shiny.host", "127.0.0.1"),
  stdout = "|",
  stderr = "|",
  env = NULL,
  ...
) {
  if (!is.null(ui) || !is.null(server)) {
    app <- shiny::shinyApp(ui, server)
  } else if (!is.null(appFile)) {
    app <- shiny::shinyAppFile(appFile)
  } else if (!is.null(appDir)) {
    app <- shiny::shinyAppDir(appDir)
  } else {
    stop(
      "You must define either 'ui'/'server', 'appFile', or 'appDir'",
      call. = FALSE
    )
  }

  # callr::rcmd_safe_env() generates some default named character vector to
  # be appended with your arguments
  if(is.null(env)){
    env <- callr::rcmd_safe_env()
  }else{
    env <-c(callr::rcmd_safe_env(), env)
  }

  run_app <- function(appDir, host, port) {
    shiny::runApp(appDir, host = host, port = port)
  }
  args <- list(appDir = app, host = host, port = port)

  if (port %in% app_manager$list_ports()) {
    app_manager$kill_app(port)
  }

  app <- callr::r_bg(
    func = run_app,
    args = args,
    stdout = stdout,
    stderr = stderr,
    env = env,
    ...
  )

  app_manager$register_app(port, app)
  app
}
