# blair3sat/gnuradio:python
FROM blair3sat/gnuradio-deps

ARG INSTALL_DIR="/miniconda3"
ARG CONDA_VERSION="latest"
# 4.7.11

COPY ./scripts/install-conda.sh /blair3sat/scripts/install-conda.sh
RUN /blair3sat/scripts/install-conda.sh ${INSTALL_DIR} ${CONDA_VERSION}

COPY ./scripts /blair3sat/scripts

RUN /blair3sat/scripts/docker-install.sh ${INSTALL_DIR}