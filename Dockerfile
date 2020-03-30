FROM debian:sid
MAINTAINER mark@heily.com
RUN apt-get update && apt-get install -y build-essential
RUN apt-get install -y cmake debhelper
WORKDIR /tmp
COPY libkqueue_2.3.1.orig.tar.gz /tmp
RUN tar zxf libkqueue_2.3.1.orig.tar.gz
COPY debian/ /tmp/libkqueue-2.3.1/debian/
WORKDIR /tmp/libkqueue-2.3.1/
