#!/bin/bash
MY_TARGZ="civicrm-4.1.5-drupal6.tar.gz"

# TODO: if Civi tarball is not found, perhaps we should try to download it.
if [[ ! ( -f "${ABS_CALLPATH}/${MY_TARGZ}" ) ]]; then
	echo "This script assumes the Civi tarball is in the same directory as this upgrade script, and we couldn't find ${MY_TARGZ}" 1>&2
	exit 1
fi

# Exit immediately if a command exits with a non-zero status.
set -e

cd "${WEBROOT}"

echo "Ensuring CIVICRM_UF is set correctly..."
sed -i "s/define( 'CIVICRM_UF'               , 'Drupal'        );/define( 'CIVICRM_UF'               , 'Drupal6'        );/" \
  "${WEBROOT}"/sites/default/civicrm.settings.php

# drush civicrm-upgrade has not been reliable for us, so we unpack the tar ourselves and run
# drush civicrm-upgrade-db, which *HAS* been reliable
echo "Replacing CiviCRM core files..."
rm -rf "${WEBROOT}"/sites/all/modules/civicrm
tar -C "${WEBROOT}"/sites/all/modules/ -xzf "${ABS_CALLPATH}/${MY_TARGZ}"

#echo "Creating civicrm_setting table..."
#mysql chorusad_civic3x < "${ABS_CALLPATH}/civicrm_setting.sql"

#echo "Running the database upgrade. Please be patient; this could take a while..."
#drush civicrm-upgrade-db # or go to /?q=civicrm/upgrade&reset=1

exit 1