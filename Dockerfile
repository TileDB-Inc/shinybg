FROM jupyter/minimal-notebook:latest
ENV AWS_EC2_METADATA_DISABLED true

# USER root
# RUN apt-get update && apt-get install --no-install-recommends -y \
#     && apt-get clean \
#     && apt-get purge -y \
#     && rm -rf /var/lib/apt/lists*

# dependencies
RUN conda install -c conda-forge --quiet --yes 'mamba'
RUN mamba install -c conda-forge --quiet --yes \
  'bash_kernel' \
  'r-shiny' \
  'r-irkernel' \
  'r-future' \
  && mamba clean --all -f -y

# install the tiledbJupyterShiny package
WORKDIR /tmp
COPY --chown=$NB_UID . tiledbJupyterShiny/
RUN R CMD build tiledbJupyterShiny \
  && R CMD INSTALL tiledbJupyterShiny_*.tar.gz \
  && rm -rf tiledbJupyterShiny*

# register kernel for current R installation
RUN Rscript -e "IRkernel::installspec()"

WORKDIR $HOME
