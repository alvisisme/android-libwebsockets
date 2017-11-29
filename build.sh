#!/bin/bash

# 当一个命令执行失败时，shell会立即退出
set -e
# path to NDK
# export NDK=/opt/android-ndk

[ ! -d libwebsockets ] && {
git clone https://github.com/warmcat/libwebsockets.git
cd libwebsockets
git checkout -b v2.4.1 v2.4.1
patch -p0 < ../CMakeLists.txt.patch
cd ..
}


echo $"Choose arch you like to build, arm(1) or arm64(2)? (1/2)"
read ans;

case $ans in
    1)
        ARCH=arm
        TOOLCHAIN_NAME=arm-linux-android-4.9
        TOOL_PREFIX=arm-linux-androideabi-;;
    2)
       	ARCH=arm64
       	TOOLCHAIN_NAME=aarch64-linux-android-4.9
       	TOOL_PREFIX=aarch64-linux-android-;;
    *)
        exit;;
esac

 # create a local android toolchain
$NDK/build/tools/make-standalone-toolchain.sh \
   --force \
   --arch=${ARCH} \
   --platform=android-21 \
   --toolchain=${TOOLCHAIN_NAME} \
   --install-dir=`pwd`/${ARCH}

 # setup environment to use the gcc/ld from the android toolchain
export TOOLCHAIN_PATH=`pwd`/${ARCH}/bin
export TOOL=${TOOL_PREFIX}
export NDK_TOOLCHAIN_BASENAME=${TOOLCHAIN_PATH}/${TOOL}
export CC=${NDK_TOOLCHAIN_BASENAME}gcc
export CXX=${NDK_TOOLCHAIN_BASENAME}g++
export LINK=${CXX}
export LD=${NDK_TOOLCHAIN_BASENAME}ld
export AR=${NDK_TOOLCHAIN_BASENAME}ar
export RANLIB=${NDK_TOOLCHAIN_BASENAME}ranlib
export STRIP=${NDK_TOOLCHAIN_BASENAME}strip

echo 'add zlib'
# configure and build zlib
cp -r thirdparty/zlib/${ARCH}/include ${ARCH}
cp thirdparty/zlib/${ARCH}/lib/libz.a ${ARCH}/lib/libz.a
echo 'add zlib done'

echo 'add openssl'
# configure and build openssl
cp -r thirdparty/openssl/${ARCH}/include/openssl ${ARCH}/include/openssl
cp thirdparty/openssl/${ARCH}/lib/libcrypto.a ${ARCH}/lib/libcrypto.a
cp thirdparty/openssl/${ARCH}/lib/libssl.a ${ARCH}/lib/libssl.a
echo 'add openssl done'

echo 'add libuv'
# configure and build libuv
cp -r thirdparty/libuv/${ARCH}/include/libuv ${ARCH}/include/libuv
cp thirdparty/libuv/${ARCH}/lib/libuv.a ${ARCH}/lib/libuv.a
echo 'add libuv done'

# configure and build libwebsockets
cd libwebsockets
[ -d build ] && {
    rm -rf build
}
mkdir -p build
cd build
PATH=$TOOLCHAIN_PATH:$PATH cmake \
  -DCMAKE_C_COMPILER=$CC \
  -DCMAKE_AR=$AR \
  -DCMAKE_RANLIB=$RANLIB \
  -DCMAKE_C_FLAGS="$CFLAGS" \
  -DCMAKE_INSTALL_PREFIX=$TOOLCHAIN_PATH/.. \
  -DLWS_WITH_SHARED=ON \
  -DLWS_WITH_STATIC=ON \
  -DLWS_WITHOUT_DAEMONIZE=ON \
  -DLWS_WITHOUT_TESTAPPS=ON \
  -DLWS_IPV6=OFF \
  -DLWS_WITHOUT_TEST_SERVER=OFF \
  -DLWS_WITH_SSL=ON \
  -DLWS_WITH_HTTP2=ON \
  -DLWS_WITH_LIBUV=ON \
  -DLWS_WITH_PLUGINS=ON \
  -DLWS_WITH_LWSWS=ON \
  -DLWS_OPENSSL_LIBRARIES="$TOOLCHAIN_PATH/../lib/libssl.a;$TOOLCHAIN_PATH/../lib/libcrypto.a" \
  -DLWS_OPENSSL_INCLUDE_DIRS="$TOOLCHAIN_PATH/../include" \
  -DLWS_LIBUV_LIBRARIES="${TOOLCHAIN_PATH}/../lib/libuv.a" \
  -DLWS_LIBUV_INCLUDE_DIRS="${TOOLCHAIN_PATH}/../include/libuv" \
  -DCMAKE_BUILD_TYPE=Debug \
  ..
PATH=$TOOLCHAIN_PATH:$PATH make
PATH=$TOOLCHAIN_PATH:$PATH make install
cd ../..
