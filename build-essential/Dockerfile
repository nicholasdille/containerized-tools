FROM ubuntu:20.04@sha256:1d7b639619bdca2d008eca2d5293e3c43ff84cbee597ff76de3b7a7de3e84956
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
 && apt-get -y install \
        build-essential \
        autoconf \
        autogen \
        ca-certificates \
        git \
        make \
        curl \
        jq