#!/bin/bash

#
# The quantum-sp8de installation script for quantra via docker
#


IMG_NAME="docker_quantra"
QCICADA_LIB="/opt/qrng/cicada-pkcs11.so"


if ! command -v docker -v &> /dev/null
then
    echo "'docker' command is not found. Please install docker or podman first"
    exit 1
fi

if ! [[ -f $QCICADA_LIB ]]; then
  echo "QCicada library is not found. Please, install QCicada hardware first"
  exit 3
fi

cat << EOF | docker build --no-cache -t $IMG_NAME -
FROM ubuntu:18.04

RUN apt-get update -y && \
    apt-get install -y curl wget

RUN curl -s https://raw.githubusercontent.com/quantum-sp8de/quantra-installer/master/install_qrandom.sh | bash -s -- -r generator
RUN mkdir -p /opt/qrng && chmod 777 /opt/qrng/

WORKDIR /tmp
EOF

# create quantra config directory for future sharing
mkdir -p ~/.quantra
mkdir -p ~/bin

# download dquantra binary
wget  https://raw.githubusercontent.com/quantum-sp8de/quantra-installer/master/docker/dquantra -O ~/bin/dquantra
chmod +x ~/bin/dquantra

echo -e "Installation OK\nRun 'dquantra' to start working"
exit 0
