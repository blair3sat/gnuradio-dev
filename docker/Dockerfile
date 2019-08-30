FROM ubuntu:18.04

#  doxygen libuhd-dev uhd-hostx
ARG packages="git cmake g++ libboost-all-dev libcppunit-dev liblog4cpp5-dev libgmp-dev swig libfftw3-dev libcomedi-dev libsdl1.2-dev libgsl-dev libqwt-qt5-dev libqt5opengl5-dev libzmq3-dev adwaita-icon-theme-full"
RUN \
    apt-get -qq update && \
    apt-get -yq install ${packages}

RUN apt-get -yq install wget

ARG INSTALL_DIR="/miniconda3"
ARG CONDA_VERSION="latest"
# 4.7.11

COPY ./scripts/install-conda.sh /blair3sat/scripts/install-conda.sh
RUN /blair3sat/scripts/install-conda.sh ${INSTALL_DIR} ${CONDA_VERSION}

COPY ./scripts /blair3sat/scripts

RUN /blair3sat/scripts/docker-install.sh ${INSTALL_DIR}