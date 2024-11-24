#!/bin/bash

#
# The main quantum-sp8de installation script
#

ARCH=$(arch)

DEB_QINSTALLER="https://github.com/quantum-sp8de/quantra-installer/raw/master/qinstaller_1.2-1.deb"
DEB_QUANTRA="https://github.com/quantum-sp8de/quantra-installer/raw/master/python3-quantra_0.3.19-1_all.deb"
DEB_QUANTRALIB="https://github.com/quantum-sp8de/quantra-installer/raw/master/python3-quantralib_2.3.6-1_all.deb"
DEB_COLANDER="http://security.ubuntu.com/ubuntu/pool/universe/p/python-colander/python3-colander_1.0b1-3_all.deb"
DEB_BASE58="http://security.ubuntu.com/ubuntu/pool/universe/p/python-base58/python3-base58_1.0.3-1_all.deb"
EOS_DEB_UBUNTU_18_04="https://github.com/EOSIO/eos/releases/download/v2.1.0/eosio_2.1.0-1-ubuntu-18.04_amd64.deb"
EOS_DEB_UBUNTU_20_04="https://github.com/EOSIO/eos/releases/download/v2.1.0/eosio_2.1.0-1-ubuntu-20.04_amd64.deb"
DEB_QGRAPHER_18_04="https://github.com/quantum-sp8de/quantra-installer/raw/master/python3-qcrypgrapher_1.0-1.deb"
DEB_QGRAPHER_20_04="https://github.com/quantum-sp8de/quantra-installer/raw/master/python3-qcrypgrapher_2.1-1_amd64.deb"
if [ "$ARCH" == "x86_64" ]; then
  DEB_QGRAPHER_22_04="https://github.com/quantum-sp8de/quantra-installer/raw/master/python3-qcrypgrapher_3.0-1.deb"
elif [ "$ARCH" == "armv7l" ]; then
  DEB_QGRAPHER_22_04="https://github.com/quantum-sp8de/quantra-installer/raw/master/python3-qcrypgrapher_3.1-1_armhf.deb"
else
  echo "Not supported arch: $ARCH"
  exit 1
fi
DEB_CHIP_CONVERTER_UBUNTU="https://github.com/quantum-sp8de/quantra-installer/raw/master/qrng-chip-converter_1.1-1.deb"

DEB_OPENSSL_1_1_FOR_UBUNTU_22_04="http://security.ubuntu.com/ubuntu/pool/main/o/openssl/openssl_1.1.1f-1ubuntu2.23_amd64.deb"
DEB_LIBSSL_DEV_1_1_FOR_UBUNTU_22_04="http://security.ubuntu.com/ubuntu/pool/main/o/openssl/libssl-dev_1.1.1f-1ubuntu2.23_amd64.deb"
DEB_LIBSSL_1_1_FOR_UBUNTU_22_04="http://security.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2.23_amd64.deb"

usage() { echo "Usage: $0 [-r <validator|generator|user>]" 1>&2; exit 1; }

__install_deb_url() {
    PKGS=""
    apt update -y
    for x in $@; do
        TEMP_DEB="$(mktemp --suffix ".deb")"
        wget -O "$TEMP_DEB" $x
        chmod 444 $TEMP_DEB
        PKGS="$PKGS $TEMP_DEB"
    done
    apt install -y --allow-downgrades $PKGS
    rm -f "$PKGS"
}

if [ "$(id -u)" -ne 0 ]
  then echo "Please run as root to install"
  exit 1
fi

source /etc/os-release

while getopts ":r:" o; do
    case "${o}" in
        r)
            r=${OPTARG}
            if [ "$r" == "validator" ]; then
                [ "$ARCH" != "x86_64" ] && { echo "Not supported arch: $ARCH"; exit 1;}
                TO_CHECK="qinstaller"
                if [ "$VERSION_CODENAME" == "bionic" ]; then
                    PKGS="$EOS_DEB_UBUNTU_18_04 $DEB_QINSTALLER"
                elif [ "$VERSION_CODENAME" == "focal" ]; then
                    PKGS="$EOS_DEB_UBUNTU_20_04 $DEB_QINSTALLER"
                elif [ "$VERSION_CODENAME" == "jammy" ]; then
                    PKGS="$DEB_LIBSSL_1_1_FOR_UBUNTU_22_04 $DEB_LIBSSL_1_1_FOR_UBUNTU_22_04 $DEB_OPENSSL_1_1_FOR_UBUNTU_22_04 $EOS_DEB_UBUNTU_20_04 $DEB_QINSTALLER"
                fi
            elif [ "$r" == "generator" ]; then
                TO_CHECK="quantra"
                if [ "$VERSION_CODENAME" == "focal" ]; then
                    [ "$ARCH" != "x86_64" ] && { echo "Not supported arch: $ARCH"; exit 1;}
                    PKGS="$DEB_QUANTRA $DEB_QUANTRALIB $DEB_QGRAPHER_20_04 $DEB_CHIP_CONVERTER_UBUNTU $DEB_COLANDER"
                elif [ "$VERSION_CODENAME" == "jammy" ]; then
                    if [ "$ARCH" != "x86_64" ] && [ "$ARCH" != "armv7l" ]; then
                        echo "Not supported arch: $ARCH"
                        exit 1
                    fi
                    PKGS="$DEB_QUANTRA $DEB_QUANTRALIB $DEB_QGRAPHER_22_04 $DEB_CHIP_CONVERTER_UBUNTU $DEB_COLANDER"
                fi
            elif [ "$r" == "user" ]; then
                TO_CHECK="quantrapy"
                if [ "$VERSION_CODENAME" == "bionic" ]; then
                    [ "$ARCH" != "x86_64" ] && { echo "Not supported arch: $ARCH"; exit 1;}
                    PKGS="$DEB_QUANTRALIB $DEB_QGRAPHER_18_04 $DEB_CHIP_CONVERTER_UBUNTU $DEB_COLANDER $DEB_BASE58"
                elif [ "$VERSION_CODENAME" == "focal" ]; then
                    [ "$ARCH" != "x86_64" ] && { echo "Not supported arch: $ARCH"; exit 1;}
                    PKGS="$DEB_QUANTRALIB $DEB_QGRAPHER_20_04 $DEB_CHIP_CONVERTER_UBUNTU $DEB_COLANDER"
                elif [ "$VERSION_CODENAME" == "jammy" ]; then
                    if [ "$ARCH" != "x86_64" ] && [ "$ARCH" != "armv7l" ]; then
                        echo "Not supported arch: $ARCH"
                        exit 1
                    fi
                    PKGS="$DEB_QUANTRALIB $DEB_QGRAPHER_22_04 $DEB_CHIP_CONVERTER_UBUNTU $DEB_COLANDER"
                fi
            else
                usage
            fi
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

if [ -z "${r}" ]; then
    usage
fi

if [ -z "${PKGS}" ] || [ -z "${TO_CHECK}" ]; then
    echo "Your distro $NAME $VERSION_ID is not supported for role $r"
    echo "Installation has been aborted"
    exit 1
fi


echo "Installing: $PKGS"
__install_deb_url $PKGS

which $TO_CHECK > /dev/null
if [ $? -ne 0 ]; then
    echo "Error has been occurred while installing $r role. Please, check your system and try again"
    exit 1
fi

echo -e "Installation OK\nRun '$TO_CHECK' to start working"
exit 0
