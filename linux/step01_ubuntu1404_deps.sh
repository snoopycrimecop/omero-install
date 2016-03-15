#!/bin/bash

apt-get update
apt-get -y install \
	unzip \
	wget \
	python-{matplotlib,numpy,pip,scipy,tables,virtualenv}

apt-get -y install postgresql

# require to install Pillow
apt-get -y install \
	libtiff5-dev \
	libjpeg8-dev \
	zlib1g-dev \
	libfreetype6-dev \
	liblcms2-dev \
	libwebp-dev \
	tcl8.6-dev \
	tk8.6-dev

pip install --upgrade "Pillow<3.0"

# Django
pip install "Django>=1.8,<1.9"

service postgresql start
