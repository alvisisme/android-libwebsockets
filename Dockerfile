# https://github.com/alvisisme/docker-android-ndk/blob/r13b/Dockerfile
FROM alvisisme/docker-android-ndk:r13b

ENTRYPOINT []
CMD ["/bin/bash","/home/dev/arm64/bin/build.sh"]
VOLUME ["/home/dev/out"]

ENV PATH=$PATH:/home/dev/arm64/bin
ENV CC=/home/dev/arm64/bin/aarch64-linux-android-gcc
ENV CXX=/home/dev/arm64/bin/aarch64-linux-android-g++
ENV LINK=/home/dev/arm64/bin/aarch64-linux-android-g++
ENV LD=/home/dev/arm64/bin/aarch64-linux-android-ld
ENV AR=/home/dev/arm64/bin/aarch64-linux-android-ar
ENV RANLIB=/home/dev/arm64/bin/aarch64-linux-android-ranlib
ENV STRIP=/home/dev/arm64/bin/aarch64-linux-android-strip
ENV OBJCOPY=/home/dev/arm64/bin/aarch64-linux-android-objcopy
ENV OBJDUMP=/home/dev/arm64/bin/aarch64-linux-android-objdump
ENV NM=/home/dev/arm64/bin/aarch64-linux-android-nm
ENV AS=/home/dev/arm64/bin/aarch64-linux-android-as
ENV PLATFORM=android
ENV CFLAGS="-D__ANDROID_API__=21"

RUN sudo apt-get update && sudo DEBIAN_FRONTEND=noninteractive apt-get install -y binutils cmake
RUN /usr/local/android-ndk-r13b/build/tools/make_standalone_toolchain.py --arch arm64 --api 21 --stl gnustl --force --install-dir /home/dev/arm64
COPY build.sh /home/dev/arm64/bin/build.sh
COPY CMakeLists.txt.patch /home/dev/CMakeLists.txt.patch
COPY thirdparty/openssl/arm64/include/openssl /home/dev/arm64/include/openssl
COPY thirdparty/openssl/arm64/lib/libcrypto.a /home/dev/arm64/lib/libcrypto.a
COPY thirdparty/openssl/arm64/lib/libssl.a /home/dev/arm64/lib/libssl.a
COPY thirdparty/libuv/arm64/include/libuv /home/dev/arm64/include/libuv
COPY thirdparty/libuv/arm64/lib/libuv.a /home/dev/arm64/lib/libuv.a
