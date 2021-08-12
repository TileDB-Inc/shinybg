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
  'r-callr' \
  'r-irkernel' \
  'r-pingr' \
  && mamba clean --all -f -y

# install the shinybg package
WORKDIR /tmp
COPY --chown=$NB_UID . shinybg/
RUN R CMD build shinybg \
  && R CMD INSTALL shinybg_*.tar.gz \
  && rm -rf shinybg*

# register kernel for current R installation
RUN Rscript -e "IRkernel::installspec()"

WORKDIR $HOME
