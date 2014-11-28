#!/bin/bash

# Accepts flag --no-dev. This script is run in dev mode by default. In dev
# mode, CiviCRM is configured to send no mail at all.

if [ `whoami` != "root" ]; then
    echo >&2 "This script must be run as root. Aborting."
    exit 1
fi

CALLPATH=`dirname "$0"`
ABS_CALLPATH="`( cd \"${CALLPATH}\" && pwd -P)`"

FLAG_DEV=true
for arg in $*; do
    if [[ "$arg" == "--no-dev" ]]; then
        FLAG_DEV=false
    fi
done

if [ -f "${ABS_CALLPATH}"/master.conf ]; then
  source "${ABS_CALLPATH}"/master.conf
else
  echo "Configuration file not found"
  exit 1;
fi

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
drush -y dis variable_membership chaPurchase user_dashboard

set +e
CIVI_MODULES="`drush pml --status=enabled --pipe | grep civi`"
CIVI_MODULES_STR=""
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
chmod a+w "${WEBROOT}"/sites/default/files/
chmod -R a+w "${WEBROOT}"/sites/default/files/civicrm/

echo "Backing up PHP and template customizations..."
# next line helps with dev where we might run this script many times over
rm -rf ${WEBROOT}/sites/default/files/civicrm/custom/custom_php.4.3
mv ${WEBROOT}/sites/default/files/civicrm/custom/custom_php \
  ${WEBROOT}/sites/default/files/civicrm/custom/custom_php.4.3
# next line helps with dev where we might run this script many times over
rm -rf ${WEBROOT}/sites/default/files/civicrm/custom/custom_template.4.3
mv ${WEBROOT}/sites/default/files/civicrm/custom/custom_template \
  ${WEBROOT}/sites/default/files/civicrm/custom/custom_template.4.3

echo "Disabling custom CiviCRM extensions"
CIVI_EXT="org.chorusamerica.appealcodes org.chorusamerica.dashboard org.chorusamerica.membership.frontend.finetune"
for X in ${CIVI_EXT}; do
  drush cvapi extension.disable key=${X}
  rm -rf "${WEBROOT}"/sites/default/files/civicrm/custom/extensions/${X}
done

echo "Making CiviCRM settings file writable..."
chmod a+w "${WEBROOT}"/sites/default/civicrm.settings.php

echo "Beginning upgrade to 4.5.4..."
source "${ABS_CALLPATH}/upgrade-to-4.5.4.sh"

echo "Refreshing CiviCRM extensions list..."
drush -y cvapi extension.refresh

echo "Enabling custom CiviCRM extensions..."
for X in ${CIVI_EXT}; do
  git clone git@bitbucket.org:chorusamerica/${X}.git ${WEBROOT}/sites/default/files/civicrm/custom/extensions/${X}
  drush cvapi extension.enable key=${X}
done

echo "Enabling CiviCRM-related Drupal modules..."
drush -y en variable_membership chaPurchase user_dashboard civicrm_display_membership_date_on_confirm \
  civicrm_disable_skip_participant civicrm_custom_contribution_confirmation

echo "Re-enabling CiviCRM-related modules..."
for MOD in "${CIVI_MODULES}"; do
	if [[ "${MOD}" != "civicrm" ]]; then
		drush -y en ${MOD}
	fi
done

echo "Restoring PHP and template customizations..."
mv ${WEBROOT}/sites/default/files/civicrm/custom/custom_php.4.3 \
  ${WEBROOT}/sites/default/files/civicrm/custom/custom_php
mv ${WEBROOT}/sites/default/files/civicrm/custom/custom_template.4.3 \
  ${WEBROOT}/sites/default/files/civicrm/custom/custom_template

echo "Adjusting file ownership and permissions..."
chmod a-w "${WEBROOT}"/sites/default/civicrm.settings.php
chown -R "${WEB_USER}":"${WEB_GROUP}" "${WEBROOT}"/sites/default/files/civicrm
chmod -R o-w "${WEBROOT}"/sites/default/files/civicrm/

drush cc all # just in case

SUCCESS_MSG="Upgrade complete. Don't forget to take the site out of maintenance mode once you've verified everything looks right."
if ${FLAG_DEV}; then
  SUCCESS_MSG+=" And don't forget to disable CiviCRM debug mode"'!'
fi

echo "${SUCCESS_MSG}"