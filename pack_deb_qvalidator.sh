#!/bin/bash

NAME="qinstaller"
VERSION="1.0"
REVISION="1"
CFG_URL="https://raw.githubusercontent.com/AlexandrDedckov/config/master/config.ini"

PKG_DIR=$NAME\_$VERSION-$REVISION

mkdir -p $PKG_DIR/etc/$NAME/
mkdir -p $PKG_DIR/usr/bin/
mkdir -p $PKG_DIR/DEBIAN/


BIN_PATH=$PKG_DIR/usr/bin/$NAME
echo -e '#!/bin/bash\n' > $BIN_PATH
echo -e "nodeos --config-dir /etc/$NAME/ --delete-all-block --protocol-features-dir=/tmp/$NAME/protocol_features/" >> $BIN_PATH
chmod 755 $BIN_PATH

pushd $PKG_DIR/etc/$NAME/
wget $CFG_URL
popd

cat >$PKG_DIR/DEBIAN/control <<EOL
Package: $NAME
Version: $VERSION
Architecture: all
Depends: eosio
Maintainer: Quantcron Technologies Inc. <noreply@quantcron.com>
Description: The validator package provides EOS Block Chain setup for validator
EOL

dpkg-deb -D --build --root-owner-group $PKG_DIR
