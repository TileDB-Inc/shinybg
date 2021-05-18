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

#' @importFrom IRkernel comm_manager comm
#' @importFrom IRdisplay display_html
#' @import shiny
#' @import later
#library(future)

runServer <- function(ui) {
  app <- shinyApp(
    ui = ui,
    server = function(input, output) {
      output$plot <- renderPlot({ hist(runif(input$n)) })
    }
  )

  #callr::r_bg(runApp, args = list(app = app))

  runApp(app)
}

setupOptions <- function() {
  options("shiny.port" = 3000)
}

displayIframe <- function() {
  display_html('<iframe src="http://localhost:3000/" width=100%, height=800></iframe> ')
}

#' @export
renderShinyDashboard <- function(ui) {
  setupOptions()
  later(displayIframe, 0)
  runServer(ui)
}


