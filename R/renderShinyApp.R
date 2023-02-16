#' Render Shiny Application in a Jupyter Notebook
#'
#' @inheritParams runBackgroundApp
#' @inheritParams shiny::shinyApp
#' @importFrom IRdisplay display_html
#' @importFrom pingr is_up
#' @export

renderShinyApp <- function(
  ui = NULL,
  server = NULL,
  appFile = NULL,
  appDir = NULL,
  port = 3000,
  stdout = "|",
  stderr = "|"
) {

  # hardcode host for rendering shiny within iframe
  host <- "0.0.0.0"
  rproc <- runBackgroundApp(
    ui = ui,
    server = server,
    appFile = appFile,
    appDir = appDir,
    port = port,
    host = host,
    stdout = stdout,
    stderr = stderr
  )

  while(!pingr::is_up(destination = host, port = port)) {
    if (!rproc$is_alive()) stop(rproc$read_all_error())
    Sys.sleep(0.05)
  }

  iframe_host <- getShinyHost(port)
  displayIframe(iframe_host)
}


#' Get Shiny Host for IFrame
#' If jupyter is running inside k8s-hub create a url to use jupyter-server-proxy
#' @noRd
getShinyHost <- function(port) {
  jupyterUser <- Sys.getenv("JUPYTERHUB_USER")
  jupyterApiURL <- Sys.getenv("JUPYTERHUB_API_URL")

  if (nzchar(jupyterUser) && nzchar(jupyterApiURL)) {
    host <- sprintf("/user/%s/proxy/%s/", jupyterUser, port)
    return(host)
  }
  host <- sprintf('http://127.0.0.1:%s', port)
  return(host)
}


displayIframe <- function(host) {
  html <- sprintf('<iframe src="%s" width="100%%" style="border: 0;height: calc(100vh - 70px);margin: 0;"></iframe>', host)
  display_html(html)
}
