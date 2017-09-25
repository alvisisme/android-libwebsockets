#!/bin/bash

# Clean then Unzip
[ -d zlib-1.2.8 ] && rm -fr zlib-1.2.8
[ -d openssl-1.0.2g ] && rm -fr openssl-1.0.2g
[ -d libwebsockets ] && rm -fr libwebsockets
[ -d libuv ] && rm -fr libuv
[ -d gyp ] && rm -fr gyp
tar xf zlib-1.2.8.tar.gz
tar xf openssl-1.0.2g.tar.gz
tar xf libuv.tar.gz
mkdir -p libuv/build
mkdir -p libuv/out
tar xf gyp.tar.gz -C libuv/build
tar xf libwebsockets.tar.gz
cd libwebsockets && git checkout -b v2.3.0 v2.3.0

