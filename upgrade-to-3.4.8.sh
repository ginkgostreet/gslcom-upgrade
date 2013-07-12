#!/bin/bash
MY_TARGZ="civicrm-3.4.8-drupal.tar.gz"

# TODO: if Civi tarball is not found, perhaps we should try to download it.
if [[ ! ( -f "${ABS_CALLPATH}/${MY_TARGZ}" ) ]]; then
	echo "This script assumes the Civi tarball is in the same directory as this upgrade script, and we couldn't find ${MY_TARGZ}" 1>&2
	exit 1
fi

# Exit immediately if a command exits with a non-zero status.
set -e

cd "${WEBROOT}"

# drush civicrm-upgrade has not been reliable for us, so we unpack the tar ourselves and run
# drush civicrm-upgrade-db, which *HAS* been reliable
echo "Replacing CiviCRM core files..."
rm -rf "${WEBROOT}"/sites/all/modules/civicrm
tar -C "${WEBROOT}"/sites/all/modules/ -xzf "${ABS_CALLPATH}/${MY_TARGZ}"

echo "Patching CiviCRM 3.4.8 for PHP 5.4..."
patch -p0 < "${ABS_CALLPATH}/civicrm-3.4.8-call-timepass-by-ref.patch"

echo "Running the database upgrade. Please be patient; this could take a while..."
drush civicrm-upgrade-db # or go to /?q=civicrm/upgrade&reset=1