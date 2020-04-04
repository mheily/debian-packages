FROM debian:sid
MAINTAINER mark@heily.com
RUN apt-get update && apt-get install -y build-essential cmake debhelper devscripts lintian rsync
RUN mkdir /build
WORKDIR /build