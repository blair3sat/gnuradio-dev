#!/usr/bin/env bash

INSTALL_DIR=$1

echo "Setting up environment variables for gnuradio in $INSTALL_DIR"

# Environment var setup + config
var_tag="# gnuradio_install_variables"
if grep -Fxq "$var_tag" ~/.bashrc; then
    # code if found
    echo "Variables configured"
else
    echo "Configuring variables"
    cat <<EOF >>~/.bashrc
$var_tag
export GNU_RADIO_PATH=$INSTALL_DIR
export PATH=/opt/qt/bin:\$PATH:$INSTALL_DIR/bin
export LD_LIBRARY_PATH=/opt/qt/lib:/usr/local/lib:\$LD_LIBRARY_PATH:$INSTALL_DIR/lib
export PKG_CONFIG_PATH=/opt/qt/lib/pkgconfig:\$PKG_CONFIG_PATH:$INSTALL_DIR/lib/pkgconfig
export PYTHONPATH=$PYTHONPATH:$CONDA_PREFIX/lib/python3.7/dist-packages
EOF

fi