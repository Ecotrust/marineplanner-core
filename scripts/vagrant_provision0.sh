#!/bin/bash
# # Dependencies for OpenCV image feature detection
# apt-get install -y python-opencv python-numpy

UBUNTU_VER=$1
GEOS_VER=$2
POSTGRES_VERSION=$3
POSTGIS_VERSION=$4

# /bin/echo "deb http://apt.postgresql.org/pub/repos/apt $UBUNTU_VER-pgdg main" >> /etc/apt/sources.list
# /usr/bin/wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | sudo apt-key add -
/usr/bin/apt-get update
/usr/bin/apt-get upgrade -y
/usr/bin/apt-get install python3-venv python3-dev python3-pip -y
/usr/bin/apt-get install postgresql-$POSTGRES_VERSION postgresql-server-dev-$POSTGRES_VERSION postgresql-$POSTGRES_VERSION-postgis-$POSTGIS_VERSION postgresql-contrib -y
# /usr/bin/apt-get install pgadmin3 -y   # Do we really need this?
/usr/bin/apt-get install binutils libgeos-$GEOS_VER libproj-dev gdal-bin python-gdal -y
sed -i 's/local   all             postgres                                peer/local   all             postgres                                trust/' /etc/postgresql/$POSTGRES_VERSION/main/pg_hba.conf
/usr/sbin/service postgresql restart

# PROJ_VER=$2
# PROJ_DATUMGRID_VER=$3

# /usr/bin/apt-get install gcc make postgresql postgresql-server-dev-9.5 postgis -y
# cd /tmp &&
#   /usr/bin/wget http://download.osgeo.org/geos/geos-$GEOS_VER.tar.bz2 &&
#   tar xjf geos-$GEOS_VER.tar.bz2 &&
#   cd geos-$GEOS_VER &&
#   ./configure &&
#   make &&
#   make install &&
#   cd /tmp &&
#   wget http://download.osgeo.org/proj/proj-$PROJ_VER.tar.gz &&
#   wget http://download.osgeo.org/proj/proj-datumgrid-$PROJ_DATUMGRID_VER.tar.gz &&
#   tar xzf proj-$PROJ_VER.tar.gz &&
#   cd proj-$PROJ_VER/nad &&
#   tar xzf ../../proj-datumgrid-$PROJ_DATUMGRID_VER.tar.gz &&
#   cd .. &&
#   ./configure &&
#   make &&
#   make install
