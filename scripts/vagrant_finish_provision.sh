#!/bin/bash
PROJECT_NAME=$1
APP_NAME=$2

PROJECT_DIR=/usr/local/apps/$PROJECT_NAME
VIRTUALENV_DIR=$PROJECT_DIR/env

PYTHON=$VIRTUALENV_DIR/bin/python

### HACKY HACKS!!! (for mp-visualize, mostly)
if [ ! -e $PROJECT_DIR/$APP_NAME/static/bower_components ]; then
  `ln -s $PROJECT_DIR/bower_components/ $PROJECT_DIR/$APP_NAME/static/bower_components`
fi

if [ ! -e $PROJECT_DIR/$APP_NAME/static/bundles ]; then
  `ln -s $PROJECT_DIR/assets/javascript/ $PROJECT_DIR/$APP_NAME/static/bundles`
fi

`$PYTHON $PROJECT_DIR/$APP_NAME/manage.py migrate`
`$PYTHON $PROJECT_DIR/$APP_NAME/manage.py collectstatic`
`$PYTHON $PROJECT_DIR/$APP_NAME/manage.py compress`
