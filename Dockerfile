FROM alvisisme/arm64-android-toolchain

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends binutils cmake git patch

COPY build.sh /build.sh
COPY CMakeLists.txt.patch /CMakeLists.txt.patch
COPY thirdparty /thirdparty

VOLUME ["/home/out"]
CMD ["/bin/bash", "/build.sh"]
