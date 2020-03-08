# See https://github.com/alvisisme/docker-android-ndk
FROM alvisisme/android-ndk:r13b

RUN apt-get update \
     && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends binutils cmake git patch

RUN /bin/bash /android-ndk-r13b/build/tools/make-standalone-toolchain.sh \
        --arch=arm64 \
        --platform=android-21 \
        --toolchain=aarch64-linux-android-4.9 \
        --stl=libc++ \
        --install-dir=/arm64-android-toolchain

ENV PATH=/arm64-android-toolchain/bin:$PATH
ENV CC=/arm64-android-toolchain/bin/aarch64-linux-android-gcc
ENV CXX=/arm64-android-toolchain/bin/aarch64-linux-android-g++
ENV LINK=/arm64-android-toolchain/bin/aarch64-linux-android-g++
ENV LD=/arm64-android-toolchain/bin/aarch64-linux-android-ld
ENV AR=/arm64-android-toolchain/bin/aarch64-linux-android-ar
ENV RANLIB=/arm64-android-toolchain/bin/aarch64-linux-android-ranlib
ENV STRIP=/arm64-android-toolchain/bin/aarch64-linux-android-strip
ENV OBJCOPY=/arm64-android-toolchain/bin/aarch64-linux-android-objcopy
ENV OBJDUMP=/arm64-android-toolchain/bin/aarch64-linux-android-objdump
ENV NM=/arm64-android-toolchain/bin/aarch64-linux-android-nm
ENV AS=/arm64-android-toolchain/bin/aarch64-linux-android-as
ENV SYSROOT=/arm64-android-toolchain/sysroot

COPY build.sh /build.sh
COPY CMakeLists.txt /CMakeLists.txt
COPY thirdparty /thirdparty

VOLUME ["/build"]
CMD ["/bin/bash", "/build.sh"]
