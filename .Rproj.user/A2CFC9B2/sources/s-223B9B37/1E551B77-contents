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

sendShinyData <- function() {
  commManager <- comm_manager()
  commChan <- commManager$new_comm("render_dashboard_iframe")
  commChan$open()
  data <- list(host = "http://localhost", port = "3000", type = "show")
  commChan$send(data)

  commChan$close()
}


#' @export
renderShinyDashboard <- function() {
  commManager <- comm_manager()

  target_handler <- function(comm, data) {
    cat('Got open call\n')
    print(data)

    comm$on_msg(function(msg) {
      print('Got message\n')
      print(msg)
      print('Sending shiny data...')
      sendShinyData()
      data <- list(foo = "bazz")
      msg$send(data)
      comm$close()
    })

    comm$on_close(function() {
      cat('Got close\n')
    })
  }

  commManager$register_target("jupyter_shiny_widget", target_handler)

  # commChan <- commManager$new_comm("render_dashboard_iframe")
  # commChan$open()
  # data <- list(foo = "bar")
  # commChan$send(data)

  # commChan$close()
  print("Registered targets")
}


