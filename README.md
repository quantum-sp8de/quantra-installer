# qinstaller

This repo contains installer and binaries for **quantum-sp8de** project

## INSTALLATION

`curl -s https://raw.githubusercontent.com/quantum-sp8de/quantra-installer/master/install_qrandom.sh | sudo bash -s -- -r ROLE`

where **ROLE** is one of the following values:
* validator
* generator
* user

## Supported distro and roles to install 

* Ubuntu 16.04: validator
* Ubuntu 18.04: validator, user
* Ubuntu 20.04: generator, user
* Ubuntu 22.04: generator, user (but see note below)

## INSTALLATION IN DOCKER CONTAINER (experemental, generator only)

Prerequisites:

* QCicada hardware and library installed
* Podman or Docker installed

`curl -s https://raw.githubusercontent.com/quantum-sp8de/quantra-installer/master/docker/install_quantra_docker.sh | bash -s`

After finishing, run in terminal **dquantra-registration** to register your device.
After registration, run your quantra application via Docker with **dquantra** command in terminal.

#### NOTES:
* If you have error accessing QCicada device like the following

`could not open port /dev/ttyUSB0: [Errno 13] Permission denied`

do not forget to add user to dialout group to access serial devices and then re-login/reboot:

`sudo usermod -a -G dialout $USER`

* If you have error during installation of docker quantra like the following

`permission denied while trying to connect to the Docker daemon socket`

do not forget to add user to docker group and re-login with user:

`sudo usermod -aG docker ${USER}`

* In case of errors on Ubuntu 22.04 like the following:

 > ValueError: unsupported hash type rmd160

make sure the following fixes are made for enabling
old crypto algo support in /usr/lib/ssl/openssl.cnf:

```
 openssl_conf = openssl_init

 [openssl_init]
 providers = provider_sect

 [provider_sect]
 default = default_sect
 legacy = legacy_sect

 [default_sect]
 activate = 1

 [legacy_sect]
 activate = 1
```
