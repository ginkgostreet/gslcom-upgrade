#!/bin/bash

##########
# config #
##########
WEBDIR="../../htdocs"
WEB_USER="www-data"
WEB_GROUP="www-data"
###########
# /config #
###########

if [ `whoami` != "root" ]; then
    echo >&2 "This script must be run as root. Aborting."
    exit 1
fi

CALLPATH=`dirname "$0"`
ABS_CALLPATH="`( cd \"${CALLPATH}\" && pwd -P)`"
WEBROOT="${ABS_CALLPATH}/${WEBDIR}"

# Exit immediately if a command exits with a non-zero status.
set -e

cd "${WEBROOT}"

echo "Putting site into maintenance mode..."
drush vset -y maintenance_mode 1
drush cc all # just in case

echo "Deleting legacy custom reports..."
rm -rf "${WEBROOT}/ca_cust_rpt"

echo "Salvaging custom module variable_membership..."
drush -y dis variable_membership
# next line helps with dev where we might run this script many times over
rm -rf "${WEBROOT}/sites/all/modules/variable_membership"
mv "${WEBROOT}/sites/all/modules/civicrm/drupal/modules/variable_membership" \
  "${WEBROOT}/sites/all/modules/"

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
	WHERE TABLE_SCHEMA =  'chorusad_civic3x'
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

echo "Making CiviCRM settings file writable..."
chmod a+w sites/default/civicrm.settings.php

echo "Beginning upgrade to 3.4.8..."
source "${ABS_CALLPATH}/upgrade-to-3.4.8.sh"

echo "Beginning upgrade to 4.1.5..."
source "${ABS_CALLPATH}/upgrade-to-4.1.5.sh"

echo "Beginning upgrade to 4.3.5..."
source "${ABS_CALLPATH}/upgrade-to-4.3.5.sh"

echo "Cleaning up extraneous financial data..."
mysql < chorusad_civic3x "${ABS_CALLPATH}/clean-up-extraneous-financial-data.sql"

echo "Re-enabling CiviCRM-related modules..."
for MOD in "${CIVI_MODULES}"; do
	if [[ "${MOD}" != "civicrm" ]]; then
		drush -y en ${MOD}
	fi
done

echo "Adjusting file ownership and permissions..."
chmod a-w sites/default/civicrm.settings.php
chown -R "${WEB_USER}":"${WEB_GROUP}" "${WEBROOT}"/sites/default/files/civicrm
chmod -R o-w sites/default/files/civicrm/

echo "Taking site out of maintenance mode..."
drush vset -y maintenance_mode 0
drush cc all # just in case