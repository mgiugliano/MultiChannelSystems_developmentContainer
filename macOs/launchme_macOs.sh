#!/usr/bin/env bash

# macOs compile and link script
# 14/9/2018 - Michele Giugliano, Trieste
#

echo "This bash script should be run under macOs to produce MC_Stream include and lib files."

GITHUB="https://github.com/mgiugliano/MultiChannelSystems_developmentContainer"

echo "-- Downloading from GitHub..."
curl -sLO $GITHUB/raw/master/MCStreamANSILib.tgz
curl -sLO $GITHUB/raw/master/boost_1_44_0.tar.gz

echo "-- Unpacking the archives..."
tar -xzf MCStreamANSILib.tgz
tar -xzf boost_1_44_0.tar.gz

mkdir lib
mkdir include

echo "-- Compiling (a subset of) Boost Lib v. 1.44..."
cd boost_1_44_0
./bootstrap.sh --prefix=../
./bjam --prefix=../ --with-system threading=multi --layout=tagged --with-filesystem
./bjam --prefix=../ --with-system threading=multi --layout=tagged --with-system
echo "-- Copying (generated) libraries and include files.."
mv ./stage/lib/* ../lib/
mv ./boost ../include/
cd ..

export BOOST_PATH=$(pwd)
export BOOSTOBJECTS="$(pwd)/lib/libboost_filesystem-mt.dylib $(pwd)/lib/libboost_system-mt.dylib"

echo "-- Compiling MCStream Library..."
cd MC_StreamAnsiLib/source

export ARCH="-arch x86_64"
export CSOFLAG=""
export LSOFLAGS="-dynamiclib -Wl,-dylib_install_name"
export SOEXT="dylib"

make
echo "-- Copying (generated) libraries and include files.."
mv ../lib/* ../../lib/
cp ../include/* ../../include

cd ../..

echo "-- Cleaning up..."
rm MCStreamANSILib.tgz
rm boost_1_44_0.tar.gz

mkdir src
mv boost_1_44_0 src/
mv MC_StreamAnsiLib src/

echo "-- Process completed!"
echo "The folder <src> can be deleted while <lib> and <include> are the result of all the compilation and linking steps."
