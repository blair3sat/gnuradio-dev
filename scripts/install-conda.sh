#!/usr/bin/env bash
# Regular: INSTALL_DIR=$HOME/miniconda3
# Docker: INSTALL_DIR=/miniconda3
INSTALL_DIR=$1
CONDA_VERSION=${2:-4.6.14}

echo "Installing miniconda version $CONDA_VERSION to $INSTALL_DIR"

wget https://repo.anaconda.com/miniconda/Miniconda3-${CONDA_VERSION}-Linux-x86_64.sh -O /tmp/miniconda.sh
bash /tmp/miniconda.sh -b -p ${INSTALL_DIR}
rm /tmp/miniconda.sh

echo "done"

# The profile file (which we source from) must not be dependent on the interactivity of the session,
# as this is a non-interactive script
profile_file=~/.bash_profile
conda_setup_key="# >>> gnuradio conda setup >>>"

echo "Adding ${INSTALL_DIR}/etc/profile.d/conda.sh to $profile_file"

if grep -Fxq "$conda_setup_key" $profile_file 2>/dev/null; then
    echo Conda setup identifier already exists
else

    echo "$conda_setup_key" >>$profile_file
    cat ${INSTALL_DIR}/etc/profile.d/conda.sh >>$profile_file
fi

. $profile_file
conda init bash

wget -q https://gist.githubusercontent.com/rytse/dd66e066b4b218022ac111e4a3618660/raw/23020fd5b396f956647c306dc6eff786f32b7cad/gr_py3_env.yml

echo "Creating conda environment from yaml packages file ..."
conda env create -f gr_py3_env.yml
echo "Done!"