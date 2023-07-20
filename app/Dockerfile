FROM ubuntu:xenial

WORKDIR /work

ENV PATH=/work/flutter/bin:$PATH

RUN apt-get update && \
    apt-get install -y curl git libgtk-3-dev pkg-config unzip xz-utils && \
    rm -rf /var/lib/apt/lists/* && \
    curl -fsSL https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.10.6-stable.tar.xz | \
      tar xJ && \
    flutter --disable-telemetry

ENV PATH=$PATH:/work/clang+llvm-12.0.1-x86_64-linux-gnu-ubuntu-/bin
RUN curl -fsSLo /tmp/llvm.txz \
      https://github.com/llvm/llvm-project/releases/download/llvmorg-12.0.1/clang+llvm-12.0.1-x86_64-linux-gnu-ubuntu-16.04.tar.xz && \
    tar xf /tmp/llvm.txz

RUN curl -fsSLo /tmp/cmake.sh \
      https://github.com/Kitware/CMake/releases/download/v3.27.0/cmake-3.27.0-linux-x86_64.sh && \
    chmod +x /tmp/cmake.sh && \
    /tmp/cmake.sh --prefix=/usr/local --skip-license

RUN curl -fsSLo /tmp/ninja.zip \
      https://github.com/ninja-build/ninja/releases/download/v1.11.1/ninja-linux.zip && \
    unzip /tmp/ninja.zip && \
    mv ninja /usr/local/bin

RUN curl -fsSLo /tmp/appimage-builder \
      https://github.com/AppImageCrafters/appimage-builder/releases/download/v1.1.0/appimage-builder-1.1.0-x86_64.AppImage && \
    chmod +x /tmp/appimage-builder && \
    /tmp/appimage-builder --appimage-extract > /dev/null && \
    ln -s /work/squashfs-root/AppRun /usr/local/bin/appimage-builder

# app

WORKDIR app

COPY . .
