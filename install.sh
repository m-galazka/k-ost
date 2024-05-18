#!/usr/bin/env bash

chmod 755 "${PWD}"/bin/k-ost.sh
[ ! -d "/usr/local/bin/" ] && mkdir /usr/local/bin/
ln -s "${PWD}"/bin/k-ost.sh /usr/local/bin/k-ost

[ ! -d "/usr/local/etc/" ] && mkdir /usr/local/etc/
ln -s "${PWD}"/etc/k-ost.config /usr/local/etc/k-ost.config

exit 0