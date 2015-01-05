#!/bin/bash
MY_VER=4.5.5
MY_TARGZ="civicrm-${MY_VER}-drupal.tar.gz"

if [[ ! ( -f "${ABS_CALLPATH}/tars/${MY_TARGZ}" ) ]]; then
  wget -P ${ABS_CALLPATH}/tars/ wget "http://downloads.sourceforge.net/project/civicrm/civicrm-stable/${MY_VER}/${MY_TARGZ}"
fi

if [[ ! ( -f "${ABS_CALLPATH}/tars/${MY_TARGZ}" ) ]]; then
  echo "${MY_TARGZ} was not found and could not be downloaded" 1>&2
  exit 1
fi

# Exit immediately if a command exits with a non-zero status.
set -e

# drush civicrm-upgrade has not been reliable for us, so we unpack the tar ourselves and run
# drush civicrm-upgrade-db, which *HAS* been reliable
echo "Replacing CiviCRM core files..."
rm -rf "${WEBROOT}"/sites/all/modules/civicrm
tar -C "${WEBROOT}"/sites/all/modules/ -xzf "${ABS_CALLPATH}/tars/${MY_TARGZ}"

echo "Running the database upgrade. Please be patient; this could take a while..."
cd "${WEBROOT}"/sites/default
drush civicrm-upgrade-db # or go to /?q=civicrm/upgrade&reset=1
