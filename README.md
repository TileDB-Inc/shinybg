## Render shiny apps inside a jupyter notebook

[![R-CMD-check](https://github.com/TileDB-Inc/TileDB-Jupyter-Shiny/workflows/R-CMD-check/badge.svg)](https://github.com/TileDB-Inc/TileDB-Jupyter-Shiny/actions)
## Example

```
library(tiledbJupyterShiny)
renderShinyApp(
  appFile = system.file(
    "inst/apps/sever-info-app.R", 
    package = "tiledbJupyterShiny"
  )
)
```
## Running in Docker

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
