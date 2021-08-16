# shinybg

[![R-CMD-check](https://github.com/TileDB-Inc/shinybg/workflows/R-CMD-check/badge.svg)](https://github.com/TileDB-Inc/shinybg/actions)

## Overview

Run and manage Shiny applications as background processes.

With *shinybg* you can:

* launch a Shiny application without locking your current R session
* run multiple applications at once
* embed application in Jupyter notebooks

## Installation

*shinybg* is currently under active development and is not yet available on CRAN. You can install the development version from GitHub:

```r
remotes::install_github("tiledb-inc/shinybg", remotes::github_release())
```

## Usage

### Basic app management

Create two instances of the same app on ports 3001 and 3002.

```r
app <- system.file("apps/sever-info-app.R", package = "shinybg")
app1 <- runBackgroundApp(appFile = app, port = 3001)
app2 <- runBackgroundApp(appFile = app, port = 3002)
```

### Jupyter integration

You can test out embedding Shiny applications in a Jupter notebook using the provided [Dockerfile][]. Pre-built images are available on [Docker Hub](https://hub.docker.com/repository/docker/tiledb/shinybg) or you can build it yourself by running:

```sh
docker build -t tiledb/shinybg:latest .
```

Next, run the container, forwarding ports 8888 for the Jupyter server and 3000 for the embedded Shiny app.

```sh
docker run --rm \
  -p 8888:8888 \
  -p 3000:3000 \
  -e JUPYTER_ENABLE_LAB=yes \
  -v $PWD/dev:/home/jovyan/work \
  tiledb/shinybg:latest
```

Within the Jupyter environment, launch an R-kernel Jupyter notebook and paste the following chunk into the first cell:

```r
library(shiny)
library(shinybg)

renderShinyApp(
    appFile = system.file("apps/sever-info-app.R", package = "shinybg")
)
```

## Get in touch

- [@tiledb](https://twitter.com/tiledb)
- [TileDB Community Slack](https://tiledb-community.slack.com)
- [TileDB Support Forum](https://forum.tiledb.com)

