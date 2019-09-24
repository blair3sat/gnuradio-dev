# blair3sat/gnuradio-deps
FROM ubuntu:18.04

#  doxygen libuhd-dev uhd-hostx
ARG packages="git cmake g++ wget libboost-all-dev libcppunit-dev liblog4cpp5-dev libgmp-dev swig libfftw3-dev libcomedi-dev libsdl1.2-dev libgsl-dev libqwt-qt5-dev libqt5opengl5-dev libzmq3-dev adwaita-icon-theme-full"

RUN apt-get -q update \
        && DEBIAN_FRONTEND=noninteractive \
        && apt-get -yq install ${packages}