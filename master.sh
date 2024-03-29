#!/bin/bash

# Accepts flag --no-dev. This script is run in dev mode by default. In dev
# mode, CiviCRM is configured to send no mail at all.

if [ `whoami` == "root" ]; then
    echo >&2 "Don't run as root. I need access to your environment for SSH config, git identify, etc. Aborting."
    exit 1
fi

CALLPATH=`dirname "$0"`
ABS_CALLPATH="`( cd \"${CALLPATH}\" && pwd -P)`"

if [ -f "${ABS_CALLPATH}"/master.conf ]; then
  source "${ABS_CALLPATH}"/master.conf
else
  echo "Configuration file not found"
  exit 1;
fi

FLAG_DEV=true
GIT_REMOTE=${GIT_REMOTE_DEV}
for arg in $*; do
    if [[ "$arg" == "--no-dev" ]]; then
        FLAG_DEV=false
        GIT_REMOTE=${GIT_REMOTE_LIVE}
    fi
done

# Exit immediately if a command exits with a non-zero status.
set -e

# get into a drush-friendly context
pushd ${WEBROOT}/sites/default > /dev/null

# log CiviCRM-generated email instead of sending it
if ${FLAG_DEV}; then
    sed -i "/CIVICRM_MAIL_LOG/c\define('CIVICRM_MAIL_LOG', 1);" \
        "${WEBROOT}"/sites/default/civicrm.settings.php
fi

#if ${FLAG_DEV}; then
#  echo "Enabling CiviCRM debugging..."
#  drush civicrm-enable-debug
#fi

echo "Putting site into maintenance mode..."
drush vset -y maintenance_mode 1
drush cc all # just in case

echo "Disabling CiviCRM-related Drupal modules..."
CIVI_MODULES="`drush pml --status=enabled --pipe | grep civi`"
CIVI_MODULES_STR="variable_membership chaPurchase user_dashboard"
for MOD in ${CIVI_MODULES}; do
  if [[ "${MOD}" != "civicrm" ]]; then
    CIVI_MODULES_STR="${CIVI_MODULES_STR} ${MOD}"
  fi
done
drush -y dis ${CIVI_MODULES_STR}
set -e

echo "Deleting CiviCRM cache..."
rm -rf "${WEBROOT}"/sites/default/files/civicrm/templates_c/* "${WEBROOT}"/sites/default/files/civicrm/ConfigAndLog/Config.IDS.ini

echo "Making files directory writable..."
sudo chmod a+w "${WEBROOT}"/sites/default/files/
sudo chmod -R a+w "${WEBROOT}"/sites/default/files/civicrm/

echo "Making CiviCRM settings file writable..."
chmod a+w "${WEBROOT}"/sites/default/civicrm.settings.php

echo "Fixing missing finanicial transaction issues before starting the upgrade..."
mysql ${CIVI_DB} < ${ABS_CALLPATH}/sql/transaction_fix.sql

echo "Beginning upgrade to 4.5.x..."
source "${ABS_CALLPATH}/upgrade-to-4.5.x.sh"

echo "Configuring new extensions directory..."
if ${FLAG_DEV}; then
  CIVI_SETTINGS_FILE="${WEBROOT}"/sites/default/civicrm_config.php
else
  CIVI_SETTINGS_FILE="${WEBROOT}"/sites/default/civicrm.settings.php
fi
mkdir "${WEBROOT}"/sites/default/ext
sed -i "/extensionsDir/c\$civicrm_setting['Directory Preferences']['extensionsDir'] = dirname(__FILE__) . '/ext';" \
  ${CIVI_SETTINGS_FILE}
sed -i "/extensionsURL/c\$civicrm_setting['URL Preferences']['extensionsURL'] = CIVICRM_UF_BASEURL . '/sites/default/ext';" \
  ${CIVI_SETTINGS_FILE}

echo "Refreshing CiviCRM extensions list..."
for X in ${CIVI_EXT}; do
  git clone ${GIT_REMOTE}/${X}.git ${WEBROOT}/sites/default/ext/${X}
done
drush -y cvapi extension.refresh

echo "Enabling CiviCRM-related Drupal modules..."
drush -y en ${CIVI_MODULES_STR}

echo "Adjusting file ownership and permissions..."
sudo chmod a-w "${WEBROOT}"/sites/default/civicrm.settings.php
sudo chown -R "${WEB_USER}":"${WEB_GROUP}" "${WEBROOT}"/sites/default/files/civicrm
sudo chmod -R o-w "${WEBROOT}"/sites/default/files/civicrm/

echo "Upgrading Drupal to 7.3x..."
source "${ABS_CALLPATH}/drupal-upgrade-to-7.x.sh"

echo "Fixing sidebar styling issues..."
pushd ${WEBROOT}/sites/all/themes/gsl/css/components/
rm -f ${WEBROOT}/sites/all/themes/gsl/css/components/boxes.css.patch
cp -rf ${UPGRADE_ROOT}/boxes.css.patch ${WEBROOT}/sites/all/themes/gsl/css/components/
patch -p3 boxes.css boxes.css.patch
rm -f ${WEBROOT}/sites/all/themes/gsl/css/components/boxes.css.patch

drush cc all # just in case

SUCCESS_MSG="Upgrade complete. Don't forget to take the site out of maintenance mode once you've verified everything looks right."
if ${FLAG_DEV}; then
  SUCCESS_MSG+=" And don't forget to disable CiviCRM debug mode"'!'
fi

echo "${SUCCESS_MSG}"
