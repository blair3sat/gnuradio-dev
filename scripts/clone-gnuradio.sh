#!/usr/bin/env bash
echo "Cloning gnuradio repository ..."
git clone -q --recurse-submodules --depth 1 https://github.com/gnuradio/gnuradio
cd gnuradio
git fetch -q --tags
git checkout v3.8.0.0