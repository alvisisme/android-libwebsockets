#!/bin/bash

# 当一个命令执行失败时，shell会立即退出
set -e
# path to NDK
export NDK=/opt/android-ndk
 # create a local android toolchain
$NDK/build/tools/make-standalone-toolchain.sh \
  --force \
  --arch=arm \
  --platform=android-21 \
  --toolchain=arm-linux-android-4.9 \
  --install-dir=`pwd`/android-toolchain-arm

 # setup environment to use the gcc/ld from the android toolchain
export TOOLCHAIN_PATH=`pwd`/android-toolchain-arm/bin
export TOOL=arm-linux-androideabi
export NDK_TOOLCHAIN_BASENAME=${TOOLCHAIN_PATH}/${TOOL}
export CC=$NDK_TOOLCHAIN_BASENAME-gcc
export CXX=$NDK_TOOLCHAIN_BASENAME-g++
export LINK=${CXX}
export LD=$NDK_TOOLCHAIN_BASENAME-ld
export AR=$NDK_TOOLCHAIN_BASENAME-ar
export RANLIB=$NDK_TOOLCHAIN_BASENAME-ranlib
export STRIP=$NDK_TOOLCHAIN_BASENAME-strip

# setup buildflags
export ARCH_FLAGS=""
export ARCH_LINK=
export CPPFLAGS=" ${ARCH_FLAGS} -fpic -ffunction-sections -funwind-tables -fstack-protector -fno-strict-aliasing -finline-limit=64 "
export CXXFLAGS=" ${ARCH_FLAGS} -fpic -ffunction-sections -funwind-tables -fstack-protector -fno-strict-aliasing -finline-limit=64 -frtti -fexceptions "
export CFLAGS=" ${ARCH_FLAGS} -fpic -ffunction-sections -funwind-tables -fstack-protector -fno-strict-aliasing -finline-limit=64 "
export LDFLAGS=" ${ARCH_LINK} "


echo 'build zlib'
# configure and build zlib
[ ! -f ./android-toolchain-arm/lib/libz.a ] && {
cd zlib-1.2.8
PATH=$TOOLCHAIN_PATH:$PATH ./configure --static --prefix=$TOOLCHAIN_PATH/..
PATH=$TOOLCHAIN_PATH:$PATH make
PATH=$TOOLCHAIN_PATH:$PATH make install
cd ..
}
echo 'build zlib done'

echo 'build openssl'
# configure and build openssl
{
PREFIX=$TOOLCHAIN_PATH/..
cd openssl-1.0.2g
./Configure android --prefix=${PREFIX} no-shared no-idea no-mdc2 no-rc5 no-zlib no-zlib-dynamic enable-tlsext no-ssl2 no-ssl3 enable-ec enable-ecdh enable-ecp
PATH=$TOOLCHAIN_PATH:$PATH make depend
PATH=$TOOLCHAIN_PATH:$PATH make
PATH=$TOOLCHAIN_PATH:$PATH make install_sw
cd ..
}
echo 'build openssl done'

echo 'build libuv'
# configure and build libuv
[ ! -f ./libuv/out/Debug/libuv.a ] && {
PREFIX=$TOOLCHAIN_PATH/..
cd libuv
./gyp_uv.py -Dtarget_arch=arm -DOS=android -f make-android
make -C out
cd ..
}
echo 'build libuv done'

# configure and build libwebsockets
[ ! -f ./android-toolchain-arm/lib/libwebsockets.a ] && {
cd libwebsockets
[ ! -d build ] && mkdir build
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
  -DLWS_USE_BUNDLED_ZLIB=OFF \
  -DLWS_WITH_SSL=ON \
  -DLWS_WITH_HTTP2=ON \
  -DLWS_WITH_LIBUV=ON \
  -DLWS_WITH_PLUGINS=ON \
  -DLWS_WITH_LWSWS=ON \
  -DLWS_OPENSSL_LIBRARIES="$TOOLCHAIN_PATH/../lib/libssl.a;$TOOLCHAIN_PATH/../lib/libcrypto.a" \
  -DLWS_OPENSSL_INCLUDE_DIRS=$TOOLCHAIN_PATH/../include \
  -DLWS_LIBUV_LIBRARIES="${TOOLCHAIN_PATH}/../../libuv/out/Debug/libuv.a" \
  -DLWS_LIBUV_INCLUDE_DIRS=${TOOLCHAIN_PATH}/../../libuv/include \
  -DCMAKE_BUILD_TYPE=Debug \
  ..
PATH=$TOOLCHAIN_PATH:$PATH make
PATH=$TOOLCHAIN_PATH:$PATH make install
cd ../..
}