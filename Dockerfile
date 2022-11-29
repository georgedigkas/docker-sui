# FROM rust
# FROM debian
#docker buildx build --no-cache --platform linux/amd64,linux/arm64/v8 -t georgedigkas/sui:0.16.0 --push .
FROM node:19-bullseye

ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH \
    RUST_VERSION=1.65.0

ARG MAKE_VERSION=3.25.0
ARG BINARY_URL=https://github.com/Kitware/CMake/releases/download/v3.25.0/cmake-3.25.0.tar.gz
ARG ESUM=306463f541555da0942e6f5a0736560f70c487178b9d94a5ae7f34d0538cdd48
#ARG BINARY_URL=https://github.com/Kitware/CMake/releases/download/v{MAKE_VERSION}/cmake-{MAKE_VERSION}.tar.gz
# BINARY_URL=https://github.com/Kitware/CMake/releases/download/v${MAKE_VERSION}/cmake-${MAKE_VERSION}.tar.gz

RUN apt-get update && apt-get install -y cmake clang curl git libssl-dev libclang-dev jq

RUN npm install -g pnpm

RUN set -eux; \
    dpkgArch="$(dpkg --print-architecture)"; \
    case "${dpkgArch##*-}" in \
    amd64) rustArch='x86_64-unknown-linux-gnu'; rustupSha256='5cc9ffd1026e82e7fb2eec2121ad71f4b0f044e88bca39207b3f6b769aaa799c' ;; \
    armhf) rustArch='armv7-unknown-linux-gnueabihf'; rustupSha256='48c5ecfd1409da93164af20cf4ac2c6f00688b15eb6ba65047f654060c844d85' ;; \
    arm64) rustArch='aarch64-unknown-linux-gnu'; rustupSha256='e189948e396d47254103a49c987e7fb0e5dd8e34b200aa4481ecc4b8e41fb929' ;; \
    i386) rustArch='i686-unknown-linux-gnu'; rustupSha256='0e0be29c560ad958ba52fcf06b3ea04435cb3cd674fbe11ce7d954093b9504fd' ;; \
    *) echo >&2 "unsupported architecture: ${dpkgArch}"; exit 1 ;; \
    esac; \
    url="https://static.rust-lang.org/rustup/archive/1.25.1/${rustArch}/rustup-init"; \
    wget "$url"; \
    echo "${rustupSha256} *rustup-init" | sha256sum -c -; \
    chmod +x rustup-init; \
    ./rustup-init -y --no-modify-path --profile minimal --default-toolchain $RUST_VERSION --default-host ${rustArch}; \
    rm rustup-init; \
    chmod -R a+w $RUSTUP_HOME $CARGO_HOME; \
    rustup --version; \
    cargo --version; \
    rustc --version;

RUN cargo install --force --locked --git https://github.com/MystenLabs/sui.git --branch devnet sui

EXPOSE 9000
