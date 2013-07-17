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

echo -e "\E[31mUpgrading the DB from the command line does not appear to work. Point your browser to /?q=civicrm/upgrade&reset=1.\033[0m"
read -p "Did the browser-based upgrade to 4.1.5 succeed? (A negative answer will abort this script): y/n " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo -e "\E[31mWhile you're at your web browser, delete these users: /civicrm/contact/view?reset=1&cid=30119 and /civicrm/contact/view?reset=1&cid=30120\033[0m"
  read -sn 1 -p "Once you're done, press any key to continue..."; echo
else
  echo "Installation canceled."
  exit 1;
fi