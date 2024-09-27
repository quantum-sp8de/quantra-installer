#!/bin/bash

#
# The quantum-sp8de installation script for quantra via docker
#


IMG_NAME="docker_quantra"

if ! command -v docker -v &> /dev/null
then
    echo "'docker' command is not found. Please install docker or podman first"
    exit 1
fi

cat << EOF | docker build --no-cache -t $IMG_NAME -
FROM ubuntu:20.04

RUN apt-get update -y && \
    apt-get install -y curl wget

RUN curl -s https://raw.githubusercontent.com/quantum-sp8de/quantra-installer/master/install_qrandom.sh | bash -s -- -r generator

WORKDIR /tmp
EOF

# create quantra config directory for future sharing
mkdir -p ~/.quantra
mkdir -p ~/bin

# download dquantra* binaries
wget  https://raw.githubusercontent.com/quantum-sp8de/quantra-installer/master/docker/dquantra -O ~/bin/dquantra
wget  https://raw.githubusercontent.com/quantum-sp8de/quantra-installer/master/docker/dquantra-registration -O ~/bin/dquantra-registration

chmod +x ~/bin/dquantra

echo -e "Installation OK\nRun 'dquantra' to start working"
exit 0
