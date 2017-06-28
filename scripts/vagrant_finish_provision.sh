#!/bin/bash
PROJECT_NAME=$1
APP_NAME=$2

PROJECT_DIR=/usr/local/apps/$PROJECT_NAME
VIRTUALENV_DIR=$PROJECT_DIR/env

PYTHON=$VIRTUALENV_DIR/bin/python

echo "Beginning finishing stages of provisioning"

echo "Migrating the DB"
$PYTHON $PROJECT_DIR/$APP_NAME/manage.py migrate --noinput

echo "Collecting Static Files"
yes yes | $PYTHON $PROJECT_DIR/$APP_NAME/manage.py collectstatic
rm -rf $PROJECT_DIR/static/modules

### HACKY HACKS!!! (for mp-visualize, mostly)
echo "Linking static content into static directory"
if [ ! -e $PROJECT_DIR/$APP_NAME/static/bower_components ]; then
  ln -s $PROJECT_DIR/bower_components/ $PROJECT_DIR/$APP_NAME/static/bower_components
fi

if [ ! -e $PROJECT_DIR/$APP_NAME/static/bundles ]; then
  ln -s $PROJECT_DIR/assets/javascript/ $PROJECT_DIR/$APP_NAME/static/bundles
fi
### END HACKY HACKS

echo "Compressing Files"
$PYTHON $PROJECT_DIR/$APP_NAME/manage.py compress
