#' Run Shiny App in a Background Process
#' 
#' @param ui The UI definition of the app.
#' @param port The TCP port that the application should listen on (defaults to 3000).  
#' @inheritParams shiny::shinyApp
#' @importFrom IRdisplay display_html
#' @return A [callr::r_process] object for the background Shiny app
#' @examples
#' \dontrun{
#' app <- system.file("apps/sever-info-app.R", package = "tiledbJupyterShiny")
#' bg_app <- runBackgroundApp(appFile = app, port = 3005)
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
  host = getOption("shiny.host", "127.0.0.1")
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

  run_app <- function(appDir, host, port) {
    shiny::runApp(appDir, host = host, port = port)
  }
  args <- list(appDir = app, host = host, port = port)

  callr::r_bg(
    func = run_app,
    args = args,
    supervise = TRUE
  )
  app_manager$register_app(port, app)
  app
}