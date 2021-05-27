#' Render Shiny Application in a Jupyter Notebook
#' 
#' @param ui The UI definition of the app.
#' @inheritParams shiny::shinyApp
#' @importFrom IRdisplay display_html
#' @import shiny
#' @import future
#' @export

renderShinyApp <- function(
  ui = NULL, 
  server = NULL, 
  appFile = NULL,
  appDir = NULL
) {
  port <- 3000

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

  plan(multisession)
  future::future(runApp(app, host = "0.0.0.0", port = port))

  Sys.sleep(1)
  displayIframe(port)
}


displayIframe <- function(port) {
  html <- sprintf('<iframe src="http://127.0.0.1:%s" width="100%%", height="800"></iframe>', port)
  display_html(html)
}


