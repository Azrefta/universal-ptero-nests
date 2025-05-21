#!/bin/bash

apt update -y && apt install -y \
  git \
  jq \
  file \
  unzip \
  make \
  gcc \
  g++ \
  python3 \
  libtool \
  wget \
  openssh-server
