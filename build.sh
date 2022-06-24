#!/bin/sh -ex

SRC="$1"

export DEB_BUILD_MAINT_OPTIONS="hardening=+all"

tar xf "$SRC"
cd libkqu*[0-9]
rsync -av --delete ../debian/ ./debian/
dpkg-buildpackage -uc -us
lintian -i -I --show-overrides ../*.changes
