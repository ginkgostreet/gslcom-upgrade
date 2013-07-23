-- remove extraneous KEY
ALTER TABLE `civicrm_address`
DROP INDEX `dedupe_index_postal_code`;

-- CRM-13088
ALTER TABLE `civicrm_contribution_product`
DROP FOREIGN KEY `FK_civicrm_contribution_product_financial_type_id`;
ALTER TABLE `civicrm_contribution_product`
ADD CONSTRAINT `FK_civicrm_contribution_product_financial_type_id`
  FOREIGN KEY (`financial_type_id`)
  REFERENCES `civicrm_financial_type`(`id`)
  ON DELETE SET NULL;

-- set proper default value
ALTER TABLE `civicrm_contribution_recur`
ALTER `is_email_receipt`
SET DEFAULT '1';

-- add missing ON DELETE clause
ALTER TABLE `civicrm_contribution_recur`
DROP FOREIGN KEY `FK_civicrm_contribution_recur_financial_type_id`;
ALTER TABLE `civicrm_contribution_recur`
  ADD CONSTRAINT `FK_civicrm_contribution_recur_financial_type_id`
  FOREIGN KEY (`financial_type_id`)
  REFERENCES `civicrm_financial_type` (`id`)
  ON DELETE SET NULL;

-- this table is created only on fresh installs due to a deficiency in the upgrade
CREATE TABLE IF NOT EXISTS `civicrm_official_receipt` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Receipt ID',
  `contact_id` int(10) unsigned NOT NULL COMMENT 'FK to Contact ID',
  `contact_snapshot` text COLLATE utf8_unicode_ci COMMENT 'Serialized array of contact info of payor at time receipt is created',
  `issued_date` datetime NOT NULL,
  `start_date` datetime NOT NULL,
  `end_date` datetime NOT NULL,
  `receipt_status_id` int(10) unsigned NOT NULL COMMENT 'pseudo FK to civicrm_option_value',
  `receipt_type_id` int(10) unsigned NOT NULL COMMENT 'pseudo FK to civicrm_option_value',
  `total_amount` decimal(20,2) NOT NULL COMMENT 'Total amount for this receipt.',
  `non_deductible_amount` decimal(20,2) DEFAULT NULL COMMENT 'Portion of total amount which is NOT tax deductible. Equal to total_amount for non-deductible financial types.',
  `currency` varchar(3) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '3 character string, value from config setting or input via user.',
  `msg_template_id` int(10) unsigned DEFAULT NULL COMMENT 'template used to generate receipt',
  PRIMARY KEY (`id`),
  KEY `UI_issued_date` (`issued_date`),
  KEY `UI_start_date` (`start_date`),
  KEY `UI_end_date` (`end_date`),
  KEY `UI_receipt_status_id` (`receipt_status_id`),
  KEY `UI_receipt_type_id` (`receipt_type_id`),
  KEY `FK_civicrm_official_receipt_contact_id` (`contact_id`),
  KEY `FK_civicrm_official_receipt_msg_template_id` (`msg_template_id`),
  CONSTRAINT `FK_civicrm_official_receipt_contact_id` FOREIGN KEY (`contact_id`) REFERENCES `civicrm_contact` (`id`),
  CONSTRAINT `FK_civicrm_official_receipt_msg_template_id` FOREIGN KEY (`msg_template_id`) REFERENCES `civicrm_msg_template` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;