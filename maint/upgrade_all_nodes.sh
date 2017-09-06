#!/bin/bash

sudo apt-get update && \
  sudo apt-get -y upgrade && \
  sudo apt-get autoremove && \
  sudo apt-get autoclean && \
  ssh piarmy02 sudo apt-get update && \
  ssh piarmy02 sudo apt-get -y upgrade && \
  ssh piarmy02 sudo apt-get autoremove && \
  ssh piarmy02 sudo apt-get autoclean && \
  ssh piarmy03 sudo apt-get update && \
  ssh piarmy03 sudo apt-get -y upgrade && \
  ssh piarmy03 sudo apt-get autoremove && \
  ssh piarmy03 sudo apt-get autoclean && \
  ssh piarmy04 sudo apt-get update && \
  ssh piarmy04 sudo apt-get -y upgrade && \
  ssh piarmy04 sudo apt-get autoremove && \
  ssh piarmy04 sudo apt-get autoclean