/*
 * See https://ginkgostreet.atlassian.net/browse/CA-19.
 */
ALTER TABLE `civicrm_msg_template`
DROP FOREIGN KEY `FK_civicrm_msg_template_pdf_format_id`,
DROP KEY `pdf_format_id`;