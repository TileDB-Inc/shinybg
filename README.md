## Render shiny apps inside a jupyter notebook


### Example
```
library(tiledbJupyterShiny)
library(shiny)
ui <- bootstrapPage(
      numericInput('n', 'Number of obs', 25),
      plotOutput('plot')
    )
renderShinyApp(ui)
```
### Running in Docker

Test out extension in a Dockerized Jupyter environment.


Build the image:

```
docker build -t tiledb/tiledb-jupyter-shiny:latest .
```

Run the container:

```
docker run --rm \
  -p 8888:8888 \
  -p 3000:3000 \
  -e JUPYTER_ENABLE_LAB=yes \
  -v $PWD/dev:/home/jovyan/work \
  tiledb/tiledb-jupyter-shiny:latest
```
