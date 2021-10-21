#!/bin/bash

HELMSWITCH_VERSION="0.0.5"
HELM_VERSIONS="3.5.3 2.16.11"
DEFAULT_HELM_VERSION="2.16.11"
DEFAULT_HELM3_VERSION="3.5.3"

sudo chown -R $(whoami) /usr/local/bin

# Install helmswitch
curl -sL -o helmswitch-linux-amd64.zip "https://github.com/tokiwong/helm-switcher/releases/download/v${HELMSWITCH_VERSION}/helmswitch-linux-amd64.zip" && \
  unzip helmswitch-linux-amd64.zip && rm helmswitch-linux-amd64.zip && \
  sudo mv helmswitch /usr/bin/helmswitch && \
  sudo chmod 700 /usr/bin/helmswitch

# Install 2to3 helm plugin
helmswitch ${DEFAULT_HELM3_VERSION} && \
  helm plugin install https://github.com/helm/helm-2to3 
