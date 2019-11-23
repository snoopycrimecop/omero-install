#!/bin/bash

set -e -u -x

OMEROVER=${OMEROVER:-latest}
PGVER=${PGVER:-pg10}
ICEVER=${ICEVER:-ice36}
VIRTUALENV=${VIRTUALENV:-/home/omero/omeroenv}

. settings.env
. settings-web.env

bash -eux step01_ubuntu_init.sh

# install java
bash -eux step01_ubuntu_java_deps.sh

bash -eux step01_ubuntu1604_deps.sh

# install ice
bash -eux step01_ubuntu1604_ice_deps.sh

# install Postgres
bash -eux step01_ubuntu1604_pg_deps.sh

bash -eux step02_all_setup.sh

if [[ "$PGVER" =~ ^(pg94|pg95|pg96|pg10)$ ]]; then
	bash -eux step03_all_postgres.sh
fi

cp step01_ubuntu1604_ice_venv.sh settings.env settings-web.env step04_all_omero.sh setup_omero_db.sh ~omero

# Create a virtual env to install Ice Python binding as the omero user
su - omero -c "VIRTUALENV=$VIRTUALENV bash -x step01_ubuntu1604_ice_venv.sh"

su - omero -c "OMEROVER=$OMEROVER ICEVER=$ICEVER VIRTUALENV=$VIRTUALENV bash -x step04_all_omero.sh"

su - omero -c "bash setup_omero_db.sh"

OMEROVER=$OMEROVER bash -eux step05_ubuntu1604_nginx.sh

if [ "$WEBSESSION" = true ]; then
	su - omero -c "VIRTUALENV=$VIRTUALENV bash -x step05_2_websessionconfig.sh"
fi

#If you don't want to use the init.d scripts you can start OMERO manually:
#su - omero -c ". $VIRTUALENV/bin/activate;OMERODIR=/home/omero/OMERO.server omero admin start"
#su - omero -c ". $VIRTUALENV/bin/activate;OMERODIR=/home/omero/OMERO.server omero web start"

bash -eux step06_ubuntu_daemon.sh

bash -eux step07_all_perms.sh

bash -eux step08_all_cron.sh

#service omero start
#service omero-web start
