#!/bin/sh -ex

export DEB_BUILD_MAINT_OPTIONS="hardening=+all"

tar zxf libkqueue*.gz
cd libkqu*[0-9]
rsync -av --delete ../debian/ ./debian/
dpkg-buildpackage -uc -us
lintian -i -I --show-overrides ../*.changes
