#!/usr/bin/env bash
# Make sure to exit if any sub-script fails
set -e

# Make sure we're in the right dir
cd $(dirname $0)

# Packages are already installed from docker
# Conda is installed

conda_env=dsp

# Make sure to run conda after installing
# https://github.com/conda/conda-docs/issues/566#issuecomment-501398667
. ~/.bash_profile

./clone-gnuradio.sh

cd gnuradio

../compile.sh $1/envs/$conda_env

../setup-gnuradio-vars.sh