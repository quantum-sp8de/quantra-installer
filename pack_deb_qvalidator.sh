#!/bin/bash

NAME="qinstaller"
VERSION="1.2"
REVISION="2"
CFG_URL="https://raw.githubusercontent.com/quantum-sp8de/sp8de-configs/refs/heads/master/config.ini"
GEN_URL="https://raw.githubusercontent.com/quantum-sp8de/sp8de-configs/refs/heads/master/genesis.json"
SC_URL="https://raw.githubusercontent.com/quantum-sp8de/quantra-installer/refs/heads/master/qinstaller"

PKG_DIR=$NAME\_$VERSION-$REVISION

mkdir -p $PKG_DIR/etc/$NAME/
mkdir -p $PKG_DIR/usr/bin/
mkdir -p $PKG_DIR/DEBIAN/


BIN_PATH=$PKG_DIR/usr/bin/

chmod 755 $BIN_PATH

pushd $PKG_DIR/etc/$NAME/
wget -O config.ini $CFG_URL
wget $GEN_URL
popd

pushd $BIN_PATH
wget $SC_URL
chmod 755 $NAME
popd

cat >$PKG_DIR/DEBIAN/control <<EOL
Package: $NAME
Version: $VERSION
Section: devel
Priority: optional
Architecture: all
Depends: eosio
Homepage: https://github.com/quantum-sp8de/quantra-installer
Maintainer: Qrng Solutions Ltd. support@qrng.com
Description: The validator package provides EOS Block Chain setup for validator
EOL

dpkg-deb -D --build --root-owner-group $PKG_DIR
