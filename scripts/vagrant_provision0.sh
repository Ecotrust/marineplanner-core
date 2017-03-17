#!/bin/bash
# # Dependencies for OpenCV image feature detection
# apt-get install -y python-opencv python-numpy

/usr/bin/apt-get update
/usr/bin/apt-get upgrade
/usr/bin/apt-get install python3-venv python3-dev python3-pip -y
/usr/bin/apt-get install gcc make postgresql postgresql-server-dev-9.5 postgis -y
/usr/bin/apt-get install binutils libproj-dev gdal-bin python-gdal -y
cd /tmp &&
  /usr/bin/wget http://download.osgeo.org/geos/geos-3.4.2.tar.bz2 &&
  tar xjf geos-3.4.2.tar.bz2 &&
  cd geos-3.4.2 &&
  ./configure &&
  make &&
  make install &&
  cd /tmp &&
  wget http://download.osgeo.org/proj/proj-4.9.1.tar.gz &&
  wget http://download.osgeo.org/proj/proj-datumgrid-1.5.tar.gz &&
  tar xzf proj-4.9.1.tar.gz &&
  cd proj-4.9.1/nad &&
  tar xzf ../../proj-datumgrid-1.5.tar.gz &&
  cd .. &&
  ./configure &&
  make &&
  make install
