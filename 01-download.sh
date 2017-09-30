#!/bin/bash

# Download packages libz, openssl, libuv and libwebsockets
[ ! -f zlib-1.2.8.tar.gz ] && {
wget http://prdownloads.sourceforge.net/libpng/zlib-1.2.8.tar.gz
}

[ ! -f openssl-1.0.2g.tar.gz ] && {
wget https://openssl.org/source/openssl-1.0.2g.tar.gz
}

[ ! -f libuv.tar.gz ] && {
git clone https://github.com/libuv/libuv.git
cd libuv && git checkout -b v1.9.1 v1.9.1 && cd ..
tar caf libuv.tar.gz libuv
}

[ ! -f gyp.tar.gz ] && {
git clone https://github.com/bnoordhuis/gyp.git
tar caf gyp.tar.gz gyp
}

[ ! -f libwebsockets.tar.gz ] && {
git clone https://github.com/warmcat/libwebsockets.git
cd libwebsockets && git checkout -b v2.3.0 v2.3.0 && cd ..
tar caf libwebsockets.tar.gz libwebsockets
}
