#!/bin/bash

yum -y install \
	python27 \
	python27-virtualenv \
	python27-numpy \
	libjpeg-devel \
	libpng-devel \
	libtiff-devel \
	zlib-devel \
	hdf5-devel \
	freetype-devel \
	expat-devel

# TODO: this installs a lot of unecessary packages:
yum -y groupinstall "Development Tools"

set +u
source /opt/rh/python27/enable
set -u
easy_install pip

export PYTHONWARNINGS="ignore:Unverified HTTPS request"
pip install tables matplotlib

# Cap Pillow version due to a limitation in OMERO.figure with v3.0.0
pip install "Pillow<3.0"

# Django
pip install "Django>=1.8,<1.9"

# Postgres, reconfigure to allow TCP connections
yum -y install http://yum.postgresql.org/9.4/redhat/rhel-6-x86_64/pgdg-centos94-9.4-1.noarch.rpm
yum -y install postgresql94-server postgresql94

service postgresql-9.4 initdb
sed -i.bak -re 's/^(host.*)ident/\1md5/' /var/lib/pgsql/9.4/data/pg_hba.conf
chkconfig postgresql-9.4 on
service postgresql-9.4 start
