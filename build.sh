#!/bin/bash
set -e

[ ! -d libwebsockets ] && {
git clone --branch v3.0.0 https://github.com/warmcat/libwebsockets.git
cd libwebsockets
patch -p1 < ../CMakeLists.txt.patch
cd ..
}

# configure and build libwebsockets
cd libwebsockets
[ -d build ] && {
    rm -rf build
}
mkdir -p build
cd build
cmake \
  -DCMAKE_INSTALL_PREFIX=/home/dev/out \
  -DLWS_WITHOUT_TESTAPPS=ON \
  -DLWS_WITH_SSL=OFF \
  -DLWS_WITH_LIBUV=ON \
  -DLWS_ZLIB_LIBRARIES=/home/dev/arm64/sysroot/usr/lib/libz.a \
  -DLWS_ZLIB_INCLUDE_DIRS=/home/dev/arm64/sysroot/usr/include \
  -DLWS_LIBUV_LIBRARIES="/home/dev/arm64/lib/libuv.a" \
  -DLWS_LIBUV_INCLUDE_DIRS="/home/dev/arm64/include/libuv" \
  -DCMAKE_BUILD_TYPE=Debug \
  ..

make
sudo make install