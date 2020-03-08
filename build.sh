#!/bin/bash
set -o nounset
set -o errexit

LWS_VERSION=3.0.0

CWD=$PWD
mkdir -p $CWD/build

cd $CWD/build
if [ ! -f libwebsockets.tar.gz ];then
wget https://github.com/warmcat/libwebsockets/archive/v${LWS_VERSION}.tar.gz -O libwebsockets.tar.gz
fi

if [ -d libwebsockets ];then
rm -rf libwebsockets
fi

tar xf libwebsockets.tar.gz
mv libwebsockets-$LWS_VERSION libwebsockets
cd libwebsockets
cp $CWD/CMakeLists.txt .

mkdir -p build
cd build
cmake \
  -DCMAKE_INSTALL_PREFIX=$CWD/build \
  -DLWS_WITHOUT_TESTAPPS=ON \
  -DLWS_WITH_SSL=OFF \
  -DLWS_WITH_LIBUV=ON \
  -DLWS_ZLIB_LIBRARIES="$CWD/thirdparty/zlib/arm64/lib/libz.a" \
  -DLWS_ZLIB_INCLUDE_DIRS="$CWD/thirdparty/zlib/arm64/include" \
  -DLWS_LIBUV_LIBRARIES="$CWD/thirdparty/libuv/arm64/lib/libuv.a" \
  -DLWS_LIBUV_INCLUDE_DIRS="$CWD/thirdparty/libuv/arm64/include/libuv" \
  -DCMAKE_BUILD_TYPE=Debug \
  ..

make && make install
