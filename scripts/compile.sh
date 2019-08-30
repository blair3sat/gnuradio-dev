#!/usr/bin/env bash

INSTALL_DIR=$1

USE_SUDO=$2

echo "Compiling gnuradio with python from $INSTALL_DIR ..."
mkdir build
cd build

cmake -DPYTHON_EXECUTABLE=$INSTALL_DIR/bin/python3.7 \
    -DPYTHON_INCLUDE_DIR=$INSTALL_DIR/include/python3.7m \
    -DPYTHON_LIBRARY=$INSTALL_DIR/lib/libpython3.7m.so \
    -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR ../
make -j$(nproc)

if [ -z "$USE_SUDO" ]; then
    make install
    ldconfig
else
    sudo make install
    sudo ldconfig
fi

ln -s $INSTALL_DIR/lib/python3.7/dist-packages/ $INSTALL_DIR/lib/python3.7/site-packages