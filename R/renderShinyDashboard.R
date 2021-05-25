# Hello, world!
#
# This is an example function named 'hello'
# which prints 'Hello, world!'.
#
# You can learn more about package authoring with RStudio at:
#
#   http://r-pkgs.had.co.nz/
#
# Some useful keyboard shortcuts for package authoring:
#
#   Install Package:           'Ctrl + Shift + B'
#   Check Package:             'Ctrl + Shift + E'
#   Test Package:              'Ctrl + Shift + T'

#' @importFrom IRdisplay display_html
#' @import shiny
#' @import future

port <- 3000

runServer <- function(ui) {
  options("shiny.port" = port)
  app <- shinyApp(
    ui = ui,
    options = list(host = "0.0.0.0"),
    server = function(input, output) {
      output$plot <- renderPlot({ hist(runif(input$n)) })
    }
  )

  runApp(app)
}

displayIframe <- function() {
  html <- sprintf('<iframe src="http://127.0.0.1:%s" width="100%%", height="800"></iframe>', port)
  display_html(html)
}

#' @export
renderShinyDashboard <- function(ui) {
  plan(multisession)
  future(runServer(ui))
  Sys.sleep(1)
  displayIframe()
}
