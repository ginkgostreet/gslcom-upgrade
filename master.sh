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

cd "${WEBROOT}"
drush uli

echo -e "\E[31mYou'll need to be logged in to the web UI for this to work;" \
  "use the link above for that. This is a good time to do a last-minute" \
  "sanity-check. Are you using the right .my.cnf? Did you update master.conf" \
  "prior to running the script? If in doubt, cancel this upgrade now. Are" \
  "ready to proceed? (y/n): \033[0m"
read -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "Installation canceled."
  exit 1;
fi

# log CiviCRM-generated email instead of sending it
if ${FLAG_DEV}; then
    sed -i "/CIVICRM_MAIL_LOG/c\define('CIVICRM_MAIL_LOG', 1);" \
        "${WEBROOT}"/sites/default/civicrm.settings.php
fi

if ${FLAG_DEV}; then
  echo "Enabling CiviCRM debugging..."
  drush civicrm-enable-debug
fi

echo "Putting site into maintenance mode..."
drush vset -y maintenance_mode 1
drush cc all # just in case

echo "Deleting legacy custom reports..."
rm -rf "${WEBROOT}/ca_cust_rpt"

echo "Removing custom module variable_membership..."
drush -y dis variable_membership
rm -rf "${WEBROOT}/sites/all/modules/civicrm/drupal/modules/variable_membership"

echo "Dropping crufty tables..."
DROP_QUERY=$(drush civicrm-sql-query "SET SESSION group_concat_max_len = 1000000;
	SELECT
	CONCAT(
		'DROP TABLE IF EXISTS ',
	        GROUP_CONCAT(
			CONCAT('\\\`', TABLE_NAME, '\\\`')
			SEPARATOR  ','
		)
	) as generated_query
	FROM information_schema.TABLES
	WHERE TABLE_SCHEMA =  'chorusad_civic3x'
	AND (
		TABLE_NAME LIKE  'civicrm_export_temp%'
		OR TABLE_NAME LIKE  'civicrm_import_job%'
		OR TABLE_NAME LIKE  'civicrm_task_action_temp%'
		OR TABLE_NAME LIKE  'civicrm_export_temp%'
		OR TABLE_NAME = 'x_AssociationOf'
	)" | sed 1d)
if [[ "${DROP_QUERY}" != "NULL" ]]; then
  drush civicrm-sql-query "${DROP_QUERY}"
fi

echo "Dropping non-CiviCRM views..."
DROP_QUERY=$(drush civicrm-sql-query "SET SESSION group_concat_max_len = 1000000;
	SELECT
	CONCAT(
                'DROP VIEW IF EXISTS ',
                GROUP_CONCAT(
			CONCAT('\\\`', TABLE_NAME, '\\\`')
			SEPARATOR  ','
		)
	) as generated_query
	FROM information_schema.VIEWS
	WHERE TABLE_SCHEMA =  "'"${CIVI_DB}"'"
	AND (
		TABLE_NAME LIKE  'DevRpt%'
		OR TABLE_NAME = 'PleadgeBalance'
	)" | sed 1d)
if [[ "${DROP_QUERY}" != "NULL" ]]; then
  drush civicrm-sql-query "${DROP_QUERY}"
fi

echo "Disabling CiviCRM-related modules..."
set +e
CIVI_MODULES="`drush pml --status=enabled --pipe | grep civi`"
for MOD in ${CIVI_MODULES}; do
	if [[ "${MOD}" != "civicrm" ]]; then
		drush -y dis ${MOD}
	fi
done
set -e

echo "Deleting CiviCRM cache..."
rm -rf "${WEBROOT}"/sites/default/files/civicrm/templates_c/* "${WEBROOT}"/sites/default/files/civicrm/ConfigAndLog/Config.IDS.ini

echo "Making files directory writable..."
chmod a+w "${WEBROOT}"/sites/default/files/
chmod -R a+w "${WEBROOT}"/sites/default/files/civicrm/

if [ ! -d ${WEBROOT}/sites/default/files/civicrm/custom/custom_php.3.4 ]; then
  echo "Backing up PHP overrides..."
  mv ${WEBROOT}/sites/default/files/civicrm/custom/custom_php \
    ${WEBROOT}/sites/default/files/civicrm/custom/custom_php.3.4
fi

if [ ! -d ${WEBROOT}/sites/default/files/civicrm/custom/custom_template.3.4 ]; then
  echo "Backing up template overrides..."
  mv ${WEBROOT}/sites/default/files/civicrm/custom/custom_template \
    ${WEBROOT}/sites/default/files/civicrm/custom/custom_template.3.4
fi


echo "Making CiviCRM settings file writable..."
chmod a+w "${WEBROOT}"/sites/default/civicrm.settings.php

echo "Beginning upgrade to 3.4.8..."
source "${ABS_CALLPATH}/upgrade-to-3.4.8.sh"

echo "Beginning upgrade to 4.1.5..."
source "${ABS_CALLPATH}/upgrade-to-4.1.5.sh"

echo "Beginning upgrade to 4.3.5..."
source "${ABS_CALLPATH}/upgrade-to-4.3.5.sh"

echo "Cleaning up extraneous financial data..."
mysql ${CIVI_DB} < "${ABS_CALLPATH}/clean-up-extraneous-financial-data.sql"

echo "Setting extensions directory..."
if [ ! -d ${WEBROOT}/sites/default/files/civicrm/custom/extensions ]; then
  mkdir ${WEBROOT}/sites/default/files/civicrm/custom/extensions
fi
sed -i '/ * Do not change anything below this line. Keep as is/i\
 * Set extensions directory\
 *\
 */\
global \$civicrm_setting;\
\$civicrm_setting["Directory Preferences"]["extensionsDir"] = dirname\(__FILE__\) . "/files/civicrm/custom/extensions"; \
\
\/**\
 *' sites/default/civicrm.settings.php

echo "Copying in updated PHP overrides..."
# next line helps with dev where we might run this script many times over
rm -rf "${WEBROOT}/sites/default/files/civicrm/custom/custom_php"
mv "${ABS_CALLPATH}/refactored/custom_php" \
  "${WEBROOT}/sites/default/files/civicrm/custom/custom_php"

echo "Copying in updated template overrides..."
# next line helps with dev where we might run this script many times over
rm -rf "${WEBROOT}/sites/default/files/civicrm/custom/custom_template"
mv "${ABS_CALLPATH}/refactored/custom_template" \
  "${WEBROOT}/sites/default/files/civicrm/custom/custom_template"

echo "Removing variable_membership-specific code from the theme..."
patch -p0 < "${ABS_CALLPATH}/patches/remove-variable_membership-code-from-theme.patch"

echo "Enabling refactored variable_membership module..."
# next line helps with dev where we might run this script many times over
rm -rf "${WEBROOT}/sites/all/modules/variable_membership"
mv "${ABS_CALLPATH}/refactored/modules/variable_membership" \
  "${WEBROOT}/sites/all/modules/"
drush -y en variable_membership
drush -y updatedb

echo "Enabling civicrm_display_membership_date_on_confirm module..."
# next line helps with dev where we might run this script many times over
rm -rf "${WEBROOT}/sites/all/modules/civicrm_display_membership_date_on_confirm"
mv "${ABS_CALLPATH}/refactored/modules/civicrm_display_membership_date_on_confirm" \
  "${WEBROOT}/sites/all/modules/"
drush -y en civicrm_display_membership_date_on_confirm

echo "Updating JavaScript theming related to membership forms..."
patch -p0 < "${ABS_CALLPATH}/patches/update-js-theming-of-membership-forms.patch"

echo "Removing JS override of contribution confirmation button text..."
patch -p0 < "${ABS_CALLPATH}/patches/remove-js-override-of-button-text.patch"

echo "Re-enabling CiviCRM-related modules..."
for MOD in "${CIVI_MODULES}"; do
	if [[ "${MOD}" != "civicrm" ]]; then
		drush -y en ${MOD}
	fi
done

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