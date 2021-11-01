#!/bin/bash

DEB_QINSTALLER="https://github.com/quantum-sp8de/quantra-installer/raw/master/qinstaller_1.1-1.deb"
DEB_QUANTRA="https://github.com/quantum-sp8de/quantra-installer/raw/master/python3-quantra_0.1.2-1_all.deb"
DEB_QUANTRALIB="https://github.com/quantum-sp8de/quantra-installer/raw/master/python3-quantralib_2.1.3-1_all.deb"
DEB_COLANDER="http://security.ubuntu.com/ubuntu/pool/universe/p/python-colander/python3-colander_1.0b1-3_all.deb"
DEB_BASE58="http://security.ubuntu.com/ubuntu/pool/universe/p/python-base58/python3-base58_1.0.3-1_all.deb"
EOS_DEB_UBUNTU_16_04="https://github.com/eosio/eos/releases/download/v2.0.12/eosio_2.0.12-1-ubuntu-16.04_amd64.deb"
EOS_DEB_UBUNTU_18_04="https://github.com/eosio/eos/releases/download/v2.0.12/eosio_2.0.12-1-ubuntu-18.04_amd64.deb"
DEB_QGRAPHER_18_04=""
DEB_QGRAPHER_20_04=""

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
    apt install -y $PKGS
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
                TO_CHECK="qinstaller"
                if [ "$VERSION_CODENAME" == "xenial" ]; then
                    PKGS="$EOS_DEB_UBUNTU_16_04 $DEB_QINSTALLER"
                elif [ "$VERSION_CODENAME" == "bionic" ]; then
                    PKGS="$EOS_DEB_UBUNTU_18_04 $DEB_QINSTALLER"
                fi
            elif [ "$r" == "generator" ]; then
                TO_CHECK="quantra"
                if [ "$VERSION_CODENAME" == "bionic" ]; then
                    PKGS="$DEB_QUANTRA $DEB_QUANTRALIB $DEB_QGRAPHER_18_04 $DEB_COLANDER $DEB_BASE58"
                elif [ "$VERSION_CODENAME" == "focal" ]; then
                    PKGS="$DEB_QUANTRA $DEB_QUANTRALIB $DEB_QGRAPHER_20_04 $DEB_COLANDER"
                fi
            elif [ "$r" == "user" ]; then
                TO_CHECK="quantrapy"
                if [ "$VERSION_CODENAME" == "bionic" ]; then
                    PKGS="$DEB_QUANTRALIB $DEB_QGRAPHER_18_04 $DEB_COLANDER $DEB_BASE58"
                elif [ "$VERSION_CODENAME" == "focal" ] ||; then
                    PKGS="$DEB_QUANTRALIB $DEB_QGRAPHER_20_04 $DEB_COLANDER"
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
