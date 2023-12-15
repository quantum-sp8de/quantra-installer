#!/bin/bash

#
# The quantum-sp8de installation script for quantra via docker
#


IMG_NAME="docker_quantra"


if ! command -v docker -v &> /dev/null
then
    echo "'docker' command is not found. Please install it first"
    exit 1
fi

cat << EOF | docker build -t $IMG_NAME -
FROM ubuntu:18.04

RUN apt-get update -y && \
    apt-get install -y curl wget

RUN curl -s https://raw.githubusercontent.com/quantum-sp8de/quantra-installer/master/install_qrandom.sh | bash -s -- -r generator

WORKDIR /tmp
EOF

# create quantra config directory for future sharing
mkdir -p ~/.quantra
mkdir -p ~/bin

# download dquantra binary
wget -P ~/bin https://raw.githubusercontent.com/quantum-sp8de/quantra-installer/master/docker/dquantra
chmod +x ~/bin/dquantra

exit 0
