# GNURadio with Anaconda Python 3 Installation Guide

At its current state, GNURadio 3.7 does not work out-of-the-box with Python 3. This is a guide to building GNURadio from source to use a Python 3 Anaconda environment. This setup is particularly nice since you can still easily import other Python packages with `conda` and use them inside GNURadio blocks.

## The Easy Way

Just run our super helpful installation script. It's as easy as: `./install.sh`.
It will check for the right dependencies (conda and various system packages), install them if needed, check out GNU Radio, build and install it to the right location, and add the right environment variables to `~/.bashrc` so you can get started right away.

## The Hard Way
Read this guide and follow along. The most up-to-date and correct version of the installation procedure is actually in `./install.sh`, so you may want to compare for reference. However, this version provides some valuable explanations.

This guide assumes you have installed all the system dependencies of GNURadio (not including the Python ones) and [Anaconda 3](https://www.anaconda.com/distribution/#download-section). You can find the list of system dependencies on the [GNURadio website](https://www.gnuradio.org/doc/doxygen/build_guide.html). You need all the ones that aren't called `gnuradio` or `python-*`.

## Installing Anaconda (or Miniconda)

First, we need to install miniconda. Download the installation script from their website and run it.

```bash
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh
```

## GNURadio Dependencies

From their installation guide, install the following dependencies. Some are for python not from the system PM.
Don't install these, they are included in the conda environment.

- Global Dependencies
	- git http://git-scm.com/downloads
	- cmake (>= 2.8.12) http://www.cmake.org/cmake/resources/software.html
	- boost (>= 1.48) http://www.boost.org/users/download/
	- cppunit (>= 1.12.1) http://freedesktop.org/wiki/Software/cppunit/
	- log4cpp (>= 1.0) http://log4cpp.sourceforge.net/
	- (python, don't install) mako (>= 0.4.2) http://www.makotemplates.org/download.html
- A C/C++ compiler is also required. These are known to work:
	- gcc/g++ (>= 4.4.0) https://gcc.gnu.org/install/download.html
	- clang/clang++ (>= 3.3.0) http://releases.llvm.org/download.html
- Python Wrappers
	- python (>= 2.7) http://www.python.org/download/
	- swig (>= 2.0.4) http://www.swig.org/download.html
	- numpy (>= 1.1.0) http://sourceforge.net/projects/numpy/files/NumPy/

```bash
sudo apt-get update && sudo apt-get install git cmake libboost-all-dev libcppunit-dev liblog4cpp5-dev
```

## Pulling the Source

Pull the GNURadio source and the `environment.yml` file that describes the conda environment that plays nice with GNURadio. At the time that this tutorial was written, this worked for [ 72aa97d](https://github.com/gnuradio/gnuradio/commit/72aa97daab609f907ba10b6f56b25e124945ba5a).

```bash
git clone --recurse-submodules https://github.com/gnuradio/gnuradio
cd gnuradio
wget https://gist.githubusercontent.com/rytse/dd66e066b4b218022ac111e4a3618660/raw/66aca50cc7a66e0f212301f8e700402a0a6acf7c/gr_py3_env.yml
```

## Installation

Create the conda environment (the one described by the yml file is called "dsp") and build GNURadio using the Python interpreter and libraries in the conda environment.

```bash
conda env create -f gr_py3_env.yml
conda activate dsp
mkdir build
cd build
cmake -DPYTHON_EXECUTABLE=$CONDA_PREFIX/envs/dsp/bin/python3.7 -DPYTHON_INCLUDE_DIR=$CONDA_PREFIX/envs/dsp/include/python3.7m -DPYTHON_LIBRARY=$CONDA_PREFIX/envs/dsp/lib/libpython3.7m.so -DCMAKE_INSTALL_PREFIX=$CONDA_PREFIX/envs/dsp ../
make -j$(nproc)
sudo make install
sudo ldconfig
```

## Configuring Path to GNURadio's Python Libs

By default, `make` installs to `-DCMAKE_INSTALL_PREFIX/libs/<python version>/dist-packages/`, but the conda Python interpreter looks for packages in `<prefix>/libs/<python version>/site-packages/`. Thus, we symlink to the packages installed.

```bash
ln -s $CONDA_PREFIX/envs/dsp/lib/python3.7/dist-packages $CONDA_PREFIX/envs/dsp/lib/python3.7/site-packages
```

And that's it. You should now be able to import GNURadio from `(dsp)` and run grc blocks written in `(dsp)`.

## Configuring environment variables

We set `GNU_RADIO_PATH` for future reference. We add QT and the gnuradio binaries to our path.
We add qt and GNU Radio shared libraries, `pkgconfig`, and we finally add GNU Radio python packages to `PYTHONPATH`.
```bash
export GNU_RADIO_PATH=$INSTALL_DIR
export PATH=/opt/qt/bin:\$PATH:$INSTALL_DIR/bin
export LD_LIBRARY_PATH=/opt/qt/lib:/usr/local/lib:\$LD_LIBRARY_PATH:$INSTALL_DIR/lib
export PKG_CONFIG_PATH=/opt/qt/lib/pkgconfig:\$PKG_CONFIG_PATH:$INSTALL_DIR/lib/pkgconfig
export PYTHONPATH=$PYTHONPATH:$CONDA_PREFIX/envs/dsp/lib/python3.7/dist-packages
```

## Running GRC with examples

Open `~/miniconda3/envs/dsp/share/gnuradio/examples`