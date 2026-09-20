FROM debian:sid

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    binutils \
    ca-certificates \
    dpkg-dev \
    g++ \
    gcc \
    make \
    pkg-config \
    libopencv-dev \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /work
