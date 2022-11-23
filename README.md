# qinstaller

= Supported distro and roles to install

* Ubuntu 16.04: validator
* Ubuntu 18.04: validator, generator, user
* Ubuntu 20.04: generator, user
* Ubuntu 22.04: generator, user (but see note below)

NOTES:
In case of errors on Ubuntu 22.04 like thw following:

 > ValueError: unsupported hash type rmd160


make the following fixes for enabling
old crypto algo support in /usr/lib/ssl/openssl.cnf:

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

