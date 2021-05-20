## Render shiny apps inside a jupyter notebook


### Example
```
library(tiledbJupyterShiny)
library(shiny)
ui <- bootstrapPage(
      numericInput('n', 'Number of obs', 25),
      plotOutput('plot')
    )
renderShinyDashboard(ui)
```