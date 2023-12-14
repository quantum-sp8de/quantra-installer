FROM ubuntu:18.04

# Download Package Information
RUN apt-get update -y && \
    apt-get install -y python3-tk curl wget

RUN curl -s https://raw.githubusercontent.com/quantum-sp8de/quantra-installer/master/install_qrandom.sh | bash -s -- -r generator

WORKDIR /tmp
ENTRYPOINT ["python3", "/usr/bin/quantra-gui"]
