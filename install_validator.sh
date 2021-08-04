#!/bin/bash

DEB_PKG="https://github.com/AlexandrDedckov/qinstaller/raw/master/qinstaller_1.0-1.deb"
EOS_DEB_UBUNTU_16_04="https://github.com/eosio/eos/releases/download/v2.0.12/eosio_2.0.12-1-ubuntu-16.04_amd64.deb"
EOS_DEB_UBUNTU_18_04="https://github.com/eosio/eos/releases/download/v2.0.12/eosio_2.0.12-1-ubuntu-18.04_amd64.deb"

__install_deb_url() {
    PKGS=""
    apt update -y
    for x in $@; do
        TEMP_DEB="$(mktemp --suffix ".deb")"
        wget -O "$TEMP_DEB" $x
        chmod 444 $TEMP_DEB
        PKGS="$PKGS $TEMP_DEB"
    done
    apt install -y $PKGS
    rm -f "$PKGS"
}

source /etc/os-release
if [ "$NAME" == "Ubuntu" ]; then
    echo "Detected $NAME"
    if [ "$VERSION_CODENAME" == "xenial" ]; then
        __install_deb_url $EOS_DEB_UBUNTU_16_04 $DEB_PKG
    elif [ "$VERSION_CODENAME" == "bionic" ]; then
        __install_deb_url $EOS_DEB_UBUNTU_18_04 $DEB_PKG
    else
        echo "Only packages for Ubuntu 16.04/18.04/20.04/20.10/21.04 are available for installation"
        exit 1
    fi
else
    echo "Your distro $NAME $VERSION_ID currently is not supported by script"
    echo "Installation has been aborted"
    exit 1
fi

echo -e "Installation OK\nRun 'qinstaller' to run the block chain node"
exit 0
