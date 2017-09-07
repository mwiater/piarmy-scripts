#!/bin/bash

sh /home/pi/projects/piarmy-scripts/maint/purge_caches.sh && \
  ssh piarmy02 sh /home/pi/projects/piarmy-scripts/maint/purge_caches.sh && \
  ssh piarmy03 sh /home/pi/projects/piarmy-scripts/maint/purge_caches.sh && \
  ssh piarmy04 sh /home/pi/projects/piarmy-scripts/maint/purge_caches.sh