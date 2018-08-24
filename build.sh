#!/bin/bash
mkdir -p /nginx
cd /nginx
apt-get -t stretch-backports source nginx-extras

cd /nginx/nginx-extras

dpkg-buildpackage -b
