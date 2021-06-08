#' Render Shiny Application in a Jupyter Notebook
#'
#' @param ui The UI definition of the app.
#' @inheritParams shiny::shinyApp
#' @importFrom IRdisplay display_html
#' @importFrom IRkernel comm_manager
#' @import shiny
#' @import future
#' @export

host <- ''
port <- 3000

renderShinyApp <- function(
  ui = NULL,
  server = NULL,
  appFile = NULL,
  appDir = NULL
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
  registerComm()
  plan(multisession)
  future::future(runApp(app, host = "0.0.0.0", port = port))
  Sys.sleep(0.1)
}

registerComm <- function() {
  commManager <- comm_manager()
  comm <- comm_manager()$new_comm("tdb_shiny_comm")
  comm$open()
  data <- list(type = "base_url_request")
  comm$send(data)
  comm$on_msg(function(msg) {
    if (msg$type == 'base_url_response') {
      baseUrl <- msg$base_url
      isLocalHost <- isBaseUrlLocalhost(baseUrl)
      if (isLocalHost == TRUE) {
        host <- paste('http://127.0.0.1', port, sep = ":")
        displayIframe(host)
      } else {
        host <- paste(baseUrl,'proxy/3000/', sep = "")
        displayIframe(host)
      }
    }
    comm$close()
  })
}


isBaseUrlLocalhost <- function(host) {
  isLocalHost <- grepl("localhost", host, fixed=TRUE) || grepl("127.0.0.1", host, fixed=TRUE)
  return (isLocalHost)
}

displayIframe <- function(host) {
  html <- sprintf('<iframe src="%s" width="100%%", height="800"></iframe>', host)
  display_html(html)
}


