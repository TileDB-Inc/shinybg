# tiledbJupyterShiny (development version)

* Adds `AppManager` class for managing background shiny apps
* New `runBackgroundApp()` function for launching apps as background tasks without rendering an IFrame
* New demo app for testing
* Included Jupyter notebook provides an overview of the app manager's functionality

# tiledbJupyterShiny 0.1.3

* `renderShinyApp() now detects when JupyterLab is running inside kubernetes and uses jupyter-server-proxy's endpoint to serve the shiny app  (#4)
* Improved look of IFrames by removing the border (#5) and matching the height of the viewport (#6)

# tiledbJupyterShiny 0.1.2

* Added a `NEWS.md` file to track changes to the package.
* Apps are now launched as background tasks using the *callr* package.
* We now verify an app is up and running before rendering the IFrame
