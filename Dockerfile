# Ubuntu + Havoc Teamserver
# Description: This docker file builds an Ubuntu 22.04 (current LTS) host, and builds the teamserver.
# Usage: docker build -t havoc-docker . && docker run -it havoc-docker
# Use the official Ubuntu 22.04 base image.
# Pinned to 22.04 on purpose: later releases (24.04+) no longer ship the
# python3.10 apt packages used below, which would break the build.
FROM ubuntu:22.04

# Avoid interactive tzdata/keyboard prompts during apt installs.
ENV DEBIAN_FRONTEND=noninteractive

# Set the working directory
WORKDIR /5pider

# Update the package lists and install necessary packages in one RUN command
RUN apt-get update && \
    apt-get install -y \
    software-properties-common \
    build-essential \
    curl \
    wget \
    sudo \
    python3.10 \
    python3.10-dev \
    git \
    apt-utils \
    cmake \
    libfontconfig1 \
    libglu1-mesa-dev \
    libgtest-dev \
    libspdlog-dev \
    libboost-all-dev \
    libncurses5-dev \
    libgdbm-dev \
    libssl-dev \
    libreadline-dev \
    libffi-dev \
    libsqlite3-dev \
    libbz2-dev \
    mesa-common-dev \
    qtbase5-dev \
    qtchooser \
    qt5-qmake \
    qtbase5-dev-tools \
    libqt5websockets5 \
    libqt5websockets5-dev \
    qtdeclarative5-dev \
    golang-go \
    mingw-w64 \
    libcap2-bin \
    nasm && \
    rm -rf /var/lib/apt/lists/*

# Clone the Havoc repository and build the teamserver
RUN git clone https://github.com/HavocFramework/Havoc.git && \
    cd Havoc/teamserver && \
    go mod download golang.org/x/sys && \
    go mod download github.com/ugorji/go && \
    cd .. && \
    make ts-build

# If needed, copy any files to the container here.
# COPY . /5pider

# Teamserver management port (default in profiles/*.yaotl) and the
# common HTTPS listener port. Adjust to match your C2 profile.
EXPOSE 40056
EXPOSE 443

# Default spawn to bash when entering container.
CMD ["/bin/bash"]
