#' Render Shiny Application in a Jupyter Notebook
#' 
#' @param ui The UI definition of the app.
#' @param port The TCP port that the application should listen on (defaults to 3000).  
#' @inheritParams shiny::shinyApp
#' @importFrom IRdisplay display_html
#' @import shiny
#' @importFrom callr r_bg
#' @importFrom pingr is_up
#' @export

renderShinyApp <- function(
  ui = NULL, 
  server = NULL, 
  appFile = NULL,
  appDir = NULL,
  port = 3000
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
  args <- list(appDir = app, host = "0.0.0.0", port = port)

  rproc <- callr::r_bg(
    func = run_app,
    args = args,
    supervise = TRUE
  )

  while(!pingr::is_up(destination = args$host, port = args$port)) {
    if (!rproc$is_alive()) stop(rproc$read_all_error())
    Sys.sleep(0.05)
  }
  displayIframe(port = args$port)
}


displayIframe <- function(port) {
  html <- sprintf('<iframe src="http://127.0.0.1:%s" width="100%%", height="800"></iframe>', port)
  display_html(html)
}


