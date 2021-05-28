library(shiny)

ui <- bootstrapPage(
  h3("URL components"),
  verbatimTextOutput("urlText")
)

server <- function(input, output, session) {
  output$urlText <- renderText({
    paste(sep = "",
      "protocol: ", session$clientData$url_protocol, "\n",
      "hostname: ", session$clientData$url_hostname, "\n",
      "pathname: ", session$clientData$url_pathname, "\n",
      "port: ",     session$clientData$url_port,     "\n",
      "search: ",   session$clientData$url_search,   "\n"
    )
  })
}

shinyApp(ui, server)


