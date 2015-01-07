#!/bin/bash

## -- This script is to update the Drupal core files -- ##
CMS=DRUPAL
ROOT_DIR=/var/www/ginkgostreet.localhost
WEB_ROOT_DIR=htdocs

set -e # Exit immediately if a command exits with a non-zero status.

if [[ ${CMS} == 'DRUPAL' ]]; then
  echo "Backing up website..."
  tar -cvf ${ROOT_DIR}/tars/gsl.com.htdocs-01.06.2015.tar.gz ${ROOT_DIR}/${WEB_ROOT_DIR}
fi

if [[ ${CMS} == 'DRUPAL' ]]; then
  echo "Getting a list of avalible updates and updating the core..."
  pushd ${ROOT_DIR}/${WEB_ROOT_DIR}/sites
  drush ups
  drush -y upc
  popd
fi

if [[ ${CMS} == 'DRUPAL' ]]; then
  echo "Clearing all cached files..."
  pushd ${ROOT_DIR}/${WEB_ROOT_DIR}/sites
  drush cc all
  popd
fi
