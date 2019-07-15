# Conda Install
# Source just in case conda was installed
source ~/.bashrc
if [[ -x "$(which conda)" ]]; then
    echo "Conda is installed."
else
    echo "No \`conda\` install found. Either conda has not been initialized with this shell, or is not installed."
    echo "Installing now..."

    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
    bash Miniconda3-latest-Linux-x86_64.sh
    source ~/.bashrc
fi

# Packages install
packages=(git cmake g++ libboost-all-dev libcppunit-dev liblog4cpp5-dev libgmp-dev swig libfftw3-dev libcomedi-dev libsdl1.2-dev libgsl-dev libqwt-qt5-dev libqt5opengl5-dev libzmq3-dev adwaita-icon-theme-full doxygen libuhd-dev uhd-host)

to_install=()
for i in ${!packages[@]}; do
    installed=false
    if [[ $(dpkg -s ${packages[i]} 2>/dev/null) == *"install ok installed"* ]]; then
        installed=true
    else
        to_install+=(${packages[i]})
    fi
    s=""
    [[ "$installed" == true ]] && s="installed" || s="not installed"
    echo "Package ${packages[i]} is $s"
done

if [[ ${#to_install[@]} -eq 0 ]]; then
    echo "All packages installed"
else
    echo "Installing missing packages: ${to_install[@]}"
    sudo apt-get update -qq
    sudo apt-get install ${to_install[@]} -yqq
fi

# Move to non-shared folder to install GNURadio
cd ~/

# Repository + config cloning
if [[ -d gnuradio ]]; then # for file "if [-f /home/rama/file]"
    echo "Repository already found"
else
    echo "Setting up repository ..."
    git clone -q --recurse-submodules --depth 1 https://github.com/gnuradio/gnuradio
fi
cd gnuradio
if [ ! -f gr_py3_env.yml ]; then
    echo "Downloading environment file"
    wget -q https://gist.githubusercontent.com/rytse/dd66e066b4b218022ac111e4a3618660/raw/23020fd5b396f956647c306dc6eff786f32b7cad/gr_py3_env.yml
fi

# Conda package install
conda_env_name=dsp
if [[ $(conda env list | grep $conda_env_name) == "" ]]; then
    echo "Installing conda packages from environment ..."
    conda env create -f gr_py3_env.yml
    conda activate dsp
else
    echo "Conda environment already created"
fi

# Compilation and install
INSTALL_DIR=$CONDA_PREFIX
if [ ! -d "build" ]; then
    echo "Compiling ..."
    mkdir build
    cd build

    cmake -DPYTHON_EXECUTABLE=$INSTALL_DIR/bin/python3.7 \
        -DPYTHON_INCLUDE_DIR=$INSTALL_DIR/include/python3.7m \
        -DPYTHON_LIBRARY=$INSTALL_DIR/lib/libpython3.7m.so \
        -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR ../
    make -j$(nproc)
    sudo make install
    sudo ldconfig
    ln -s $CONDA_PREFIX/lib/python3.7/dist-packages/ $CONDA_PREFIX/lib/python3.7/site-packages
fi

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
