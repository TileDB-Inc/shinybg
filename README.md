# shinybg

[![R-CMD-check](https://github.com/TileDB-Inc/shinybg/workflows/R-CMD-check/badge.svg)](https://github.com/TileDB-Inc/shinybg/actions)

Run shiny apps as background processes.

## Overview

Render shiny apps inside a jupyter notebook


## Example

```
library(shinybg)
renderShinyApp(
  appFile = system.file(
    "inst/apps/sever-info-app.R",
    package = "shinybg"
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

```sh
docker run --rm \
  -p 8888:8888 \
  -p 3000:3000 \
  -e JUPYTER_ENABLE_LAB=yes \
  -v $PWD/dev:/home/jovyan/work \
  tiledb/tiledb-jupyter-shiny:latest
```

Launch an R-kernel Jupyter notebook, copy and paste the following chunk into the first cell, and then run it:

```r
library(shiny)
library(shinybg)

renderShinyApp(
    appFile = system.file("apps/sever-info-app.R", package = "shinybg")
)
```
