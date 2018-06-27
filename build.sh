#!/bin/bash
set -e

[ ! -d libwebsockets ] && {
git clone --branch v3.0.0 https://github.com/warmcat/libwebsockets.git
cd libwebsockets
mv /CMakeLists.txt.patch .
git apply CMakeLists.txt.patch
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
  -DCMAKE_INSTALL_PREFIX=/home/out \
  -DLWS_WITHOUT_TESTAPPS=ON \
  -DLWS_WITH_SSL=OFF \
  -DLWS_WITH_LIBUV=ON \
  -DLWS_ZLIB_LIBRARIES="/thirdparty/zlib/arm64/lib/libz.a" \
  -DLWS_ZLIB_INCLUDE_DIRS="/thirdparty/zlib/arm64/include" \
  -DLWS_LIBUV_LIBRARIES="/thirdparty/libuv/arm64/lib/libuv.a" \
  -DLWS_LIBUV_INCLUDE_DIRS="/thirdparty/libuv/arm64/include/libuv" \
  -DCMAKE_BUILD_TYPE=Debug \
  ..

make
make install