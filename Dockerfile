FROM rust
# FROM debian

ARG MAKE_VERSION=3.25.0
ARG BINARY_URL=https://github.com/Kitware/CMake/releases/download/v3.25.0/cmake-3.25.0.tar.gz
ARG ESUM=306463f541555da0942e6f5a0736560f70c487178b9d94a5ae7f34d0538cdd48
#ARG BINARY_URL=https://github.com/Kitware/CMake/releases/download/v{MAKE_VERSION}/cmake-{MAKE_VERSION}.tar.gz
# BINARY_URL=https://github.com/Kitware/CMake/releases/download/v${MAKE_VERSION}/cmake-${MAKE_VERSION}.tar.gz

# RUN apt-get update \
#     && rustup update stable \
#     && apt install curl \
#     && apt-get install git-all \
#     && apt-get install libssl-dev \
#     && apt-get install libssl-dev \
#     && apt-get install libclang-dev

RUN rustup update stable
# RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
RUN apt update 
RUN apt install curl
RUN apt install git
RUN apt install libssl-dev
# RUN apt-get install git
# RUN apt-get install libssl-dev
RUN apt install libclang-dev -y

RUN curl -LfsSo /tmp/cmake.tar.gz ${BINARY_URL}; \
    echo "${ESUM} */tmp/cmake.tar.gz" | sha256sum -c -; \
    mkdir -p /opt/cmake; \
    cd /opt/cmake

RUN tar -xf /tmp/cmake.tar.gz --strip-components=1; \
    cd cmake; \
    ./bootstrap; \
    make; \
    make install

RUN cargo install --locked --git https://github.com/MystenLabs/sui.git --branch devnet sui
