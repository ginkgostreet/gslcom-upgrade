
ALTER TABLE civicrm_financial_trxn
ADD CONSTRAINT FK_civicrm_financial_trxn_from_account_id FOREIGN KEY (from_account_id) REFERENCES civicrm_financial_account(id) ,
ADD CONSTRAINT FK_civicrm_financial_trxn_to_account_id FOREIGN KEY (to_account_id) REFERENCES civicrm_financial_account(id);

ALTER TABLE civicrm_navigation
ADD CONSTRAINT FK_civicrm_navigation_domain_id FOREIGN KEY (domain_id) REFERENCES civicrm_domain(id) ,
ADD CONSTRAINT FK_civicrm_navigation_parent_id FOREIGN KEY (parent_id) REFERENCES civicrm_navigation(id) ON DELETE CASCADE;

ALTER TABLE civicrm_payment_processor
ADD CONSTRAINT FK_civicrm_payment_processor_domain_id FOREIGN KEY (domain_id) REFERENCES civicrm_domain(id);

ALTER TABLE civicrm_discount
ADD CONSTRAINT FK_civicrm_discount_option_group_id FOREIGN KEY (option_group_id) REFERENCES civicrm_option_group(id) ON DELETE CASCADE;

ALTER TABLE civicrm_contact
ADD CONSTRAINT FK_civicrm_contact_primary_contact_id FOREIGN KEY (primary_contact_id) REFERENCES civicrm_contact(id) ON DELETE SET NULL,
ADD CONSTRAINT FK_civicrm_contact_employer_id FOREIGN KEY (employer_id) REFERENCES civicrm_contact(id) ON DELETE SET NULL;

ALTER TABLE civicrm_acl_contact_cache
ADD CONSTRAINT FK_civicrm_acl_contact_cache_user_id FOREIGN KEY (user_id) REFERENCES civicrm_contact(id) ON DELETE CASCADE,
ADD CONSTRAINT FK_civicrm_acl_contact_cache_contact_id FOREIGN KEY (contact_id) REFERENCES civicrm_contact(id) ON DELETE CASCADE;

-- Resolve FK requirements
INSERT INTO `civicrm_mapping` (`id`, `name`, `description`, `mapping_type_id`)
SELECT css.`mapping_id`, NULL, 'inserted by Confluence to meet foreign key requirements', NULL
FROM `civicrm_saved_search` css
LEFT JOIN `civicrm_mapping` cm
ON css.`mapping_id` = cm.`id`
WHERE css.`mapping_id` IS NOT NULL
AND cm.`id` IS NULL

ALTER TABLE civicrm_saved_search
ADD CONSTRAINT FK_civicrm_saved_search_mapping_id FOREIGN KEY (mapping_id) REFERENCES civicrm_mapping(id);

ALTER TABLE civicrm_contact_type
ADD CONSTRAINT FK_civicrm_contact_type_parent_id FOREIGN KEY (parent_id) REFERENCES civicrm_contact_type(id);

ALTER TABLE civicrm_mailing_bounce_pattern
ADD CONSTRAINT FK_civicrm_mailing_bounce_pattern_bounce_type_id FOREIGN KEY (bounce_type_id) REFERENCES civicrm_mailing_bounce_type(id) ON DELETE CASCADE;

ALTER TABLE civicrm_contribution_recur
ADD CONSTRAINT FK_civicrm_contribution_recur_contact_id FOREIGN KEY (contact_id) REFERENCES civicrm_contact(id) ON DELETE CASCADE,
ADD CONSTRAINT FK_civicrm_contribution_recur_payment_processor_id FOREIGN KEY (payment_processor_id) REFERENCES civicrm_payment_processor(id) ON DELETE SET NULL;

ALTER TABLE civicrm_premiums_product
ADD CONSTRAINT FK_civicrm_premiums_product_premiums_id FOREIGN KEY (premiums_id) REFERENCES civicrm_premiums(id) ,
ADD CONSTRAINT FK_civicrm_premiums_product_product_id FOREIGN KEY (product_id) REFERENCES civicrm_product(id);

-- Table 'chorusad_civic3x.civicrm_task_status' doesn't exist (make sure my upgrade didn't incorrectly delete this)
ALTER TABLE civicrm_task_status
ADD CONSTRAINT FK_civicrm_task_status_task_id FOREIGN KEY (task_id) REFERENCES civicrm_task(id);

ALTER TABLE civicrm_campaign
ADD CONSTRAINT FK_civicrm_campaign_parent_id FOREIGN KEY (parent_id) REFERENCES civicrm_campaign(id) ON DELETE SET NULL,
ADD CONSTRAINT FK_civicrm_campaign_created_id FOREIGN KEY (created_id) REFERENCES civicrm_contact(id) ON DELETE SET NULL,
ADD CONSTRAINT FK_civicrm_campaign_last_modified_id FOREIGN KEY (last_modified_id) REFERENCES civicrm_contact(id) ON DELETE SET NULL;

ALTER TABLE civicrm_campaign_group
ADD CONSTRAINT FK_civicrm_campaign_group_campaign_id FOREIGN KEY (campaign_id) REFERENCES civicrm_campaign(id) ON DELETE CASCADE;

ALTER TABLE civicrm_survey
ADD CONSTRAINT FK_civicrm_survey_campaign_id FOREIGN KEY (campaign_id) REFERENCES civicrm_campaign(id) ON DELETE SET NULL,
ADD CONSTRAINT FK_civicrm_survey_created_id FOREIGN KEY (created_id) REFERENCES civicrm_contact(id) ON DELETE SET NULL,
ADD CONSTRAINT FK_civicrm_survey_last_modified_id FOREIGN KEY (last_modified_id) REFERENCES civicrm_contact(id) ON DELETE SET NULL;

ALTER TABLE civicrm_dedupe_rule
ADD CONSTRAINT FK_civicrm_dedupe_rule_dedupe_rule_group_id FOREIGN KEY (dedupe_rule_group_id) REFERENCES civicrm_dedupe_rule_group(id);

ALTER TABLE civicrm_dedupe_exception
ADD CONSTRAINT FK_civicrm_dedupe_exception_contact_id1 FOREIGN KEY (contact_id1) REFERENCES civicrm_contact(id) ON DELETE CASCADE,
ADD CONSTRAINT FK_civicrm_dedupe_exception_contact_id2 FOREIGN KEY (contact_id2) REFERENCES civicrm_contact(id) ON DELETE CASCADE;

ALTER TABLE civicrm_case_contact
ADD CONSTRAINT FK_civicrm_case_contact_case_id FOREIGN KEY (case_id) REFERENCES civicrm_case(id) ON DELETE CASCADE,
ADD CONSTRAINT FK_civicrm_case_contact_contact_id FOREIGN KEY (contact_id) REFERENCES civicrm_contact(id) ON DELETE CASCADE;

ALTER TABLE civicrm_grant
ADD CONSTRAINT FK_civicrm_grant_contact_id FOREIGN KEY (contact_id) REFERENCES civicrm_contact(id) ON DELETE CASCADE;

ALTER TABLE civicrm_report_instance
ADD CONSTRAINT FK_civicrm_report_instance_domain_id FOREIGN KEY (domain_id) REFERENCES civicrm_domain(id) ,
ADD CONSTRAINT FK_civicrm_report_instance_navigation_id FOREIGN KEY (navigation_id) REFERENCES civicrm_navigation(id) ON DELETE SET NULL;

ALTER TABLE civicrm_price_set
ADD CONSTRAINT FK_civicrm_price_set_domain_id FOREIGN KEY (domain_id) REFERENCES civicrm_domain(id) ,
ADD CONSTRAINT FK_civicrm_price_set_contribution_type_id FOREIGN KEY (contribution_type_id) REFERENCES civicrm_contribution_type(id) ON DELETE SET NULL;

ALTER TABLE civicrm_price_set_entity
ADD CONSTRAINT FK_civicrm_price_set_entity_price_set_id FOREIGN KEY (price_set_id) REFERENCES civicrm_price_set(id);

ALTER TABLE civicrm_batch
ADD CONSTRAINT FK_civicrm_batch_created_id FOREIGN KEY (created_id) REFERENCES civicrm_contact(id) ON DELETE SET NULL,
ADD CONSTRAINT FK_civicrm_batch_modified_id FOREIGN KEY (modified_id) REFERENCES civicrm_contact(id) ON DELETE SET NULL;

ALTER TABLE civicrm_cache
ADD CONSTRAINT FK_civicrm_cache_component_id FOREIGN KEY (component_id) REFERENCES civicrm_component(id);

ALTER TABLE civicrm_country
ADD CONSTRAINT FK_civicrm_country_address_format_id FOREIGN KEY (address_format_id) REFERENCES civicrm_address_format(id) ,
ADD CONSTRAINT FK_civicrm_country_region_id FOREIGN KEY (region_id) REFERENCES civicrm_worldregion(id);

ALTER TABLE civicrm_custom_group
ADD CONSTRAINT FK_civicrm_custom_group_created_id FOREIGN KEY (created_id) REFERENCES civicrm_contact(id) ON DELETE SET NULL;

ALTER TABLE civicrm_custom_field
ADD CONSTRAINT FK_civicrm_custom_field_custom_group_id FOREIGN KEY (custom_group_id) REFERENCES civicrm_custom_group(id) ON DELETE CASCADE;

ALTER TABLE civicrm_dashboard
ADD CONSTRAINT FK_civicrm_dashboard_domain_id FOREIGN KEY (domain_id) REFERENCES civicrm_domain(id);
-- FK constraint fails
ALTER TABLE civicrm_email
ADD CONSTRAINT FK_civicrm_email_contact_id FOREIGN KEY (contact_id) REFERENCES civicrm_contact(id) ON DELETE CASCADE;

ALTER TABLE civicrm_entity_batch
ADD CONSTRAINT FK_civicrm_entity_batch_batch_id FOREIGN KEY (batch_id) REFERENCES civicrm_batch(id) ON DELETE CASCADE;

ALTER TABLE civicrm_entity_file
ADD CONSTRAINT FK_civicrm_entity_file_file_id FOREIGN KEY (file_id) REFERENCES civicrm_file(id);

ALTER TABLE civicrm_entity_financial_trxn
ADD CONSTRAINT FK_civicrm_entity_financial_trxn_financial_trxn_id FOREIGN KEY (financial_trxn_id) REFERENCES civicrm_financial_trxn(id) ON DELETE SET NULL;

ALTER TABLE civicrm_im
ADD CONSTRAINT FK_civicrm_im_contact_id FOREIGN KEY (contact_id) REFERENCES civicrm_contact(id) ON DELETE CASCADE;
-- FK constraint fails
ALTER TABLE civicrm_log
ADD CONSTRAINT FK_civicrm_log_modified_id FOREIGN KEY (modified_id) REFERENCES civicrm_contact(id) ON DELETE CASCADE;

ALTER TABLE civicrm_mapping_field
ADD CONSTRAINT FK_civicrm_mapping_field_mapping_id FOREIGN KEY (mapping_id) REFERENCES civicrm_mapping(id) ,
ADD CONSTRAINT FK_civicrm_mapping_field_location_type_id FOREIGN KEY (location_type_id) REFERENCES civicrm_location_type(id) ,
ADD CONSTRAINT FK_civicrm_mapping_field_relationship_type_id FOREIGN KEY (relationship_type_id) REFERENCES civicrm_relationship_type(id);

ALTER TABLE civicrm_menu
ADD CONSTRAINT FK_civicrm_menu_domain_id FOREIGN KEY (domain_id) REFERENCES civicrm_domain(id) ,
ADD CONSTRAINT FK_civicrm_menu_component_id FOREIGN KEY (component_id) REFERENCES civicrm_component(id);
-- FK constraint fails
ALTER TABLE civicrm_note
ADD CONSTRAINT FK_civicrm_note_contact_id FOREIGN KEY (contact_id) REFERENCES civicrm_contact(id) ON DELETE SET NULL;
-- FK constraint fails (at least the first one)
ALTER TABLE civicrm_option_value
ADD CONSTRAINT FK_civicrm_option_value_option_group_id FOREIGN KEY (option_group_id) REFERENCES civicrm_option_group(id) ON DELETE CASCADE,
ADD CONSTRAINT FK_civicrm_option_value_component_id FOREIGN KEY (component_id) REFERENCES civicrm_component(id) ,
ADD CONSTRAINT FK_civicrm_option_value_domain_id FOREIGN KEY (domain_id) REFERENCES civicrm_domain(id);
-- FK constraint fails
ALTER TABLE civicrm_phone
ADD CONSTRAINT FK_civicrm_phone_contact_id FOREIGN KEY (contact_id) REFERENCES civicrm_contact(id) ON DELETE CASCADE;
-- FK constraint fails
ALTER TABLE civicrm_preferences
ADD CONSTRAINT FK_civicrm_preferences_domain_id FOREIGN KEY (domain_id) REFERENCES civicrm_domain(id) ON DELETE CASCADE,
ADD CONSTRAINT FK_civicrm_preferences_contact_id FOREIGN KEY (contact_id) REFERENCES civicrm_contact(id) ON DELETE CASCADE;

ALTER TABLE civicrm_state_province
ADD CONSTRAINT FK_civicrm_state_province_country_id FOREIGN KEY (country_id) REFERENCES civicrm_country(id);

ALTER TABLE civicrm_tag
ADD CONSTRAINT FK_civicrm_tag_parent_id FOREIGN KEY (parent_id) REFERENCES civicrm_tag(id) ,
ADD CONSTRAINT FK_civicrm_tag_created_id FOREIGN KEY (created_id) REFERENCES civicrm_contact(id) ON DELETE SET NULL;

ALTER TABLE civicrm_uf_match
ADD CONSTRAINT FK_civicrm_uf_match_domain_id FOREIGN KEY (domain_id) REFERENCES civicrm_domain(id) ,
ADD CONSTRAINT FK_civicrm_uf_match_contact_id FOREIGN KEY (contact_id) REFERENCES civicrm_contact(id) ON DELETE CASCADE;

ALTER TABLE civicrm_timezone
ADD CONSTRAINT FK_civicrm_timezone_country_id FOREIGN KEY (country_id) REFERENCES civicrm_country(id);

ALTER TABLE civicrm_openid
ADD CONSTRAINT FK_civicrm_openid_contact_id FOREIGN KEY (contact_id) REFERENCES civicrm_contact(id) ON DELETE CASCADE;
-- FK constraint fails
ALTER TABLE civicrm_website
ADD CONSTRAINT FK_civicrm_website_contact_id FOREIGN KEY (contact_id) REFERENCES civicrm_contact(id) ON DELETE CASCADE;

ALTER TABLE civicrm_acl_cache
ADD CONSTRAINT FK_civicrm_acl_cache_contact_id FOREIGN KEY (contact_id) REFERENCES civicrm_contact(id) ON DELETE CASCADE,
ADD CONSTRAINT FK_civicrm_acl_cache_acl_id FOREIGN KEY (acl_id) REFERENCES civicrm_acl(id) ON DELETE CASCADE;

ALTER TABLE civicrm_dashboard_contact
ADD CONSTRAINT FK_civicrm_dashboard_contact_dashboard_id FOREIGN KEY (dashboard_id) REFERENCES civicrm_dashboard(id) ON DELETE CASCADE,
ADD CONSTRAINT FK_civicrm_dashboard_contact_contact_id FOREIGN KEY (contact_id) REFERENCES civicrm_contact(id) ON DELETE CASCADE;

ALTER TABLE civicrm_group
ADD CONSTRAINT FK_civicrm_group_saved_search_id FOREIGN KEY (saved_search_id) REFERENCES civicrm_saved_search(id);
-- FK constraint fails (at least the first one)
ALTER TABLE civicrm_subscription_history
ADD CONSTRAINT FK_civicrm_subscription_history_contact_id FOREIGN KEY (contact_id) REFERENCES civicrm_contact(id) ON DELETE CASCADE,
ADD CONSTRAINT FK_civicrm_subscription_history_group_id FOREIGN KEY (group_id) REFERENCES civicrm_group(id) ON DELETE CASCADE;

ALTER TABLE civicrm_group_contact_cache
ADD CONSTRAINT FK_civicrm_group_contact_cache_group_id FOREIGN KEY (group_id) REFERENCES civicrm_group(id) ON DELETE CASCADE,
ADD CONSTRAINT FK_civicrm_group_contact_cache_contact_id FOREIGN KEY (contact_id) REFERENCES civicrm_contact(id) ON DELETE CASCADE;
-- FK constraint fails (at least the first one)
ALTER TABLE civicrm_group_nesting
ADD CONSTRAINT FK_civicrm_group_nesting_child_group_id FOREIGN KEY (child_group_id) REFERENCES civicrm_group(id) ON DELETE CASCADE,
ADD CONSTRAINT FK_civicrm_group_nesting_parent_group_id FOREIGN KEY (parent_group_id) REFERENCES civicrm_group(id) ON DELETE CASCADE;

ALTER TABLE civicrm_group_organization
ADD CONSTRAINT FK_civicrm_group_organization_group_id FOREIGN KEY (group_id) REFERENCES civicrm_group(id) ON DELETE CASCADE,
ADD CONSTRAINT FK_civicrm_group_organization_organization_id FOREIGN KEY (organization_id) REFERENCES civicrm_contact(id) ON DELETE CASCADE;
-- FK constraint fails (at least the first one)
ALTER TABLE civicrm_relationship
ADD CONSTRAINT FK_civicrm_relationship_contact_id_a FOREIGN KEY (contact_id_a) REFERENCES civicrm_contact(id) ON DELETE CASCADE,
ADD CONSTRAINT FK_civicrm_relationship_contact_id_b FOREIGN KEY (contact_id_b) REFERENCES civicrm_contact(id) ON DELETE CASCADE,
ADD CONSTRAINT FK_civicrm_relationship_relationship_type_id FOREIGN KEY (relationship_type_id) REFERENCES civicrm_relationship_type(id) ON DELETE CASCADE,
ADD CONSTRAINT FK_civicrm_relationship_case_id FOREIGN KEY (case_id) REFERENCES civicrm_case(id) ON DELETE CASCADE;

ALTER TABLE civicrm_mailing_event_subscribe
ADD CONSTRAINT FK_civicrm_mailing_event_subscribe_group_id FOREIGN KEY (group_id) REFERENCES civicrm_group(id) ON DELETE CASCADE,
ADD CONSTRAINT FK_civicrm_mailing_event_subscribe_contact_id FOREIGN KEY (contact_id) REFERENCES civicrm_contact(id) ON DELETE CASCADE;

ALTER TABLE civicrm_mailing_event_confirm
ADD CONSTRAINT FK_civicrm_mailing_event_confirm_event_subscribe_id FOREIGN KEY (event_subscribe_id) REFERENCES civicrm_mailing_event_subscribe(id) ON DELETE CASCADE;

ALTER TABLE civicrm_contribution_page
ADD CONSTRAINT FK_civicrm_contribution_page_contribution_type_id FOREIGN KEY (contribution_type_id) REFERENCES civicrm_contribution_type(id) ,
ADD CONSTRAINT FK_civicrm_contribution_page_payment_processor_id FOREIGN KEY (payment_processor_id) REFERENCES civicrm_payment_processor(id) ON DELETE SET NULL,
ADD CONSTRAINT FK_civicrm_contribution_page_created_id FOREIGN KEY (created_id) REFERENCES civicrm_contact(id) ON DELETE SET NULL,
ADD CONSTRAINT FK_civicrm_contribution_page_campaign_id FOREIGN KEY (campaign_id) REFERENCES civicrm_campaign(id) ON DELETE SET NULL;
-- FK constraint fails
ALTER TABLE civicrm_contribution_widget
ADD CONSTRAINT FK_civicrm_contribution_widget_contribution_page_id FOREIGN KEY (contribution_page_id) REFERENCES civicrm_contribution_page(id) ON DELETE CASCADE;

ALTER TABLE civicrm_pcp
ADD CONSTRAINT FK_civicrm_pcp_contact_id FOREIGN KEY (contact_id) REFERENCES civicrm_contact(id) ON DELETE CASCADE,
ADD CONSTRAINT FK_civicrm_pcp_contribution_page_id FOREIGN KEY (contribution_page_id) REFERENCES civicrm_contribution_page(id);
-- FK constraint fails (at least the first one)
ALTER TABLE civicrm_activity
ADD CONSTRAINT FK_civicrm_activity_source_contact_id FOREIGN KEY (source_contact_id) REFERENCES civicrm_contact(id) ON DELETE SET NULL,
ADD CONSTRAINT FK_civicrm_activity_phone_id FOREIGN KEY (phone_id) REFERENCES civicrm_phone(id) ON DELETE SET NULL,
ADD CONSTRAINT FK_civicrm_activity_parent_id FOREIGN KEY (parent_id) REFERENCES civicrm_activity(id) ON DELETE CASCADE,
ADD CONSTRAINT FK_civicrm_activity_relationship_id FOREIGN KEY (relationship_id) REFERENCES civicrm_relationship(id) ON DELETE SET NULL,
ADD CONSTRAINT FK_civicrm_activity_original_id FOREIGN KEY (original_id) REFERENCES civicrm_activity(id) ON DELETE CASCADE,
ADD CONSTRAINT FK_civicrm_activity_campaign_id FOREIGN KEY (campaign_id) REFERENCES civicrm_campaign(id) ON DELETE SET NULL;
-- FK constraint fails (at least the first one)
ALTER TABLE civicrm_activity_assignment
ADD CONSTRAINT FK_civicrm_activity_assignment_activity_id FOREIGN KEY (activity_id) REFERENCES civicrm_activity(id) ON DELETE CASCADE,
ADD CONSTRAINT FK_civicrm_activity_assignment_assignee_contact_id FOREIGN KEY (assignee_contact_id) REFERENCES civicrm_contact(id) ON DELETE CASCADE;
-- FK constraint fails (at least the first one)
ALTER TABLE civicrm_activity_target
ADD CONSTRAINT FK_civicrm_activity_target_activity_id FOREIGN KEY (activity_id) REFERENCES civicrm_activity(id) ON DELETE CASCADE,
ADD CONSTRAINT FK_civicrm_activity_target_target_contact_id FOREIGN KEY (target_contact_id) REFERENCES civicrm_contact(id) ON DELETE CASCADE;

ALTER TABLE civicrm_case_activity
ADD CONSTRAINT FK_civicrm_case_activity_case_id FOREIGN KEY (case_id) REFERENCES civicrm_case(id) ON DELETE CASCADE,
ADD CONSTRAINT FK_civicrm_case_activity_activity_id FOREIGN KEY (activity_id) REFERENCES civicrm_activity(id) ON DELETE CASCADE;
-- FK constraint fails (at least the first one)
ALTER TABLE civicrm_pledge
ADD CONSTRAINT FK_civicrm_pledge_contact_id FOREIGN KEY (contact_id) REFERENCES civicrm_contact(id) ON DELETE CASCADE,
ADD CONSTRAINT FK_civicrm_pledge_contribution_type_id FOREIGN KEY (contribution_type_id) REFERENCES civicrm_contribution_type(id) ON DELETE SET NULL,
ADD CONSTRAINT FK_civicrm_pledge_contribution_page_id FOREIGN KEY (contribution_page_id) REFERENCES civicrm_contribution_page(id) ON DELETE SET NULL,
ADD CONSTRAINT FK_civicrm_pledge_honor_contact_id FOREIGN KEY (honor_contact_id) REFERENCES civicrm_contact(id) ON DELETE SET NULL,
ADD CONSTRAINT FK_civicrm_pledge_campaign_id FOREIGN KEY (campaign_id) REFERENCES civicrm_campaign(id) ON DELETE SET NULL;

ALTER TABLE civicrm_price_field
ADD CONSTRAINT FK_civicrm_price_field_price_set_id FOREIGN KEY (price_set_id) REFERENCES civicrm_price_set(id);

ALTER TABLE civicrm_county
ADD CONSTRAINT FK_civicrm_county_state_province_id FOREIGN KEY (state_province_id) REFERENCES civicrm_state_province(id);

ALTER TABLE civicrm_entity_tag
ADD CONSTRAINT FK_civicrm_entity_tag_tag_id FOREIGN KEY (tag_id) REFERENCES civicrm_tag(id) ON DELETE CASCADE;

ALTER TABLE civicrm_msg_template
ADD CONSTRAINT FK_civicrm_msg_template_pdf_format_id FOREIGN KEY (pdf_format_id) REFERENCES civicrm_option_value(id) ON DELETE SET NULL;

ALTER TABLE civicrm_uf_group
ADD CONSTRAINT FK_civicrm_uf_group_limit_listings_group_id FOREIGN KEY (limit_listings_group_id) REFERENCES civicrm_group(id) ON DELETE SET NULL,
ADD CONSTRAINT FK_civicrm_uf_group_add_to_group_id FOREIGN KEY (add_to_group_id) REFERENCES civicrm_group(id) ON DELETE SET NULL,
ADD CONSTRAINT FK_civicrm_uf_group_created_id FOREIGN KEY (created_id) REFERENCES civicrm_contact(id) ON DELETE SET NULL;

ALTER TABLE civicrm_uf_field
ADD CONSTRAINT FK_civicrm_uf_field_uf_group_id FOREIGN KEY (uf_group_id) REFERENCES civicrm_uf_group(id) ON DELETE CASCADE,
ADD CONSTRAINT FK_civicrm_uf_field_location_type_id FOREIGN KEY (location_type_id) REFERENCES civicrm_location_type(id) ON DELETE SET NULL;

ALTER TABLE civicrm_uf_join
ADD CONSTRAINT FK_civicrm_uf_join_uf_group_id FOREIGN KEY (uf_group_id) REFERENCES civicrm_uf_group(id);

ALTER TABLE civicrm_action_schedule
ADD CONSTRAINT FK_civicrm_action_schedule_mapping_id FOREIGN KEY (mapping_id) REFERENCES civicrm_action_mapping(id) ON DELETE SET NULL,
ADD CONSTRAINT FK_civicrm_action_schedule_group_id FOREIGN KEY (group_id) REFERENCES civicrm_group(id) ON DELETE SET NULL,
ADD CONSTRAINT FK_civicrm_action_schedule_msg_template_id FOREIGN KEY (msg_template_id) REFERENCES civicrm_msg_template(id) ON DELETE SET NULL;

ALTER TABLE civicrm_action_log
ADD CONSTRAINT FK_civicrm_action_log_contact_id FOREIGN KEY (contact_id) REFERENCES civicrm_contact(id) ON DELETE CASCADE,
ADD CONSTRAINT FK_civicrm_action_log_action_schedule_id FOREIGN KEY (action_schedule_id) REFERENCES civicrm_action_schedule(id) ON DELETE CASCADE;

ALTER TABLE civicrm_mailing
ADD CONSTRAINT FK_civicrm_mailing_domain_id FOREIGN KEY (domain_id) REFERENCES civicrm_domain(id) ON DELETE SET NULL,
ADD CONSTRAINT FK_civicrm_mailing_header_id FOREIGN KEY (header_id) REFERENCES civicrm_mailing_component(id) ON DELETE SET NULL,
ADD CONSTRAINT FK_civicrm_mailing_footer_id FOREIGN KEY (footer_id) REFERENCES civicrm_mailing_component(id) ON DELETE SET NULL,
ADD CONSTRAINT FK_civicrm_mailing_reply_id FOREIGN KEY (reply_id) REFERENCES civicrm_mailing_component(id) ON DELETE SET NULL,
ADD CONSTRAINT FK_civicrm_mailing_unsubscribe_id FOREIGN KEY (unsubscribe_id) REFERENCES civicrm_mailing_component(id) ON DELETE SET NULL,
ADD CONSTRAINT FK_civicrm_mailing_optout_id FOREIGN KEY (optout_id) REFERENCES civicrm_mailing_component(id) ON DELETE SET NULL,
ADD CONSTRAINT FK_civicrm_mailing_msg_template_id FOREIGN KEY (msg_template_id) REFERENCES civicrm_msg_template(id) ON DELETE SET NULL,
ADD CONSTRAINT FK_civicrm_mailing_created_id FOREIGN KEY (created_id) REFERENCES civicrm_contact(id) ON DELETE SET NULL,
ADD CONSTRAINT FK_civicrm_mailing_scheduled_id FOREIGN KEY (scheduled_id) REFERENCES civicrm_contact(id) ON DELETE SET NULL,
ADD CONSTRAINT FK_civicrm_mailing_approver_id FOREIGN KEY (approver_id) REFERENCES civicrm_contact(id) ON DELETE SET NULL,
ADD CONSTRAINT FK_civicrm_mailing_campaign_id FOREIGN KEY (campaign_id) REFERENCES civicrm_campaign(id) ON DELETE SET NULL;

ALTER TABLE civicrm_mailing_group
ADD CONSTRAINT FK_civicrm_mailing_group_mailing_id FOREIGN KEY (mailing_id) REFERENCES civicrm_mailing(id) ON DELETE CASCADE;

ALTER TABLE civicrm_mailing_trackable_url
ADD CONSTRAINT FK_civicrm_mailing_trackable_url_mailing_id FOREIGN KEY (mailing_id) REFERENCES civicrm_mailing(id) ON DELETE CASCADE;

ALTER TABLE civicrm_mailing_job
ADD CONSTRAINT FK_civicrm_mailing_job_mailing_id FOREIGN KEY (mailing_id) REFERENCES civicrm_mailing(id) ON DELETE CASCADE,
ADD CONSTRAINT FK_civicrm_mailing_job_parent_id FOREIGN KEY (parent_id) REFERENCES civicrm_mailing_job(id) ON DELETE CASCADE;

ALTER TABLE civicrm_mailing_recipients
ADD CONSTRAINT FK_civicrm_mailing_recipients_mailing_id FOREIGN KEY (mailing_id) REFERENCES civicrm_mailing(id) ON DELETE CASCADE,
ADD CONSTRAINT FK_civicrm_mailing_recipients_contact_id FOREIGN KEY (contact_id) REFERENCES civicrm_contact(id) ON DELETE CASCADE,
ADD CONSTRAINT FK_civicrm_mailing_recipients_email_id FOREIGN KEY (email_id) REFERENCES civicrm_email(id) ON DELETE CASCADE;

ALTER TABLE civicrm_mailing_spool
ADD CONSTRAINT FK_civicrm_mailing_spool_job_id FOREIGN KEY (job_id) REFERENCES civicrm_mailing_job(id) ON DELETE CASCADE;

ALTER TABLE civicrm_mailing_event_queue
ADD CONSTRAINT FK_civicrm_mailing_event_queue_job_id FOREIGN KEY (job_id) REFERENCES civicrm_mailing_job(id) ON DELETE CASCADE,
ADD CONSTRAINT FK_civicrm_mailing_event_queue_email_id FOREIGN KEY (email_id) REFERENCES civicrm_email(id) ON DELETE CASCADE,
ADD CONSTRAINT FK_civicrm_mailing_event_queue_contact_id FOREIGN KEY (contact_id) REFERENCES civicrm_contact(id) ON DELETE CASCADE;

ALTER TABLE civicrm_mailing_event_bounce
ADD CONSTRAINT FK_civicrm_mailing_event_bounce_event_queue_id FOREIGN KEY (event_queue_id) REFERENCES civicrm_mailing_event_queue(id) ON DELETE CASCADE;

ALTER TABLE civicrm_mailing_event_delivered
ADD CONSTRAINT FK_civicrm_mailing_event_delivered_event_queue_id FOREIGN KEY (event_queue_id) REFERENCES civicrm_mailing_event_queue(id) ON DELETE CASCADE;

ALTER TABLE civicrm_mailing_event_forward
ADD CONSTRAINT FK_civicrm_mailing_event_forward_event_queue_id FOREIGN KEY (event_queue_id) REFERENCES civicrm_mailing_event_queue(id) ON DELETE CASCADE,
ADD CONSTRAINT FK_civicrm_mailing_event_forward_dest_queue_id FOREIGN KEY (dest_queue_id) REFERENCES civicrm_mailing_event_queue(id) ON DELETE SET NULL;

ALTER TABLE civicrm_mailing_event_opened
ADD CONSTRAINT FK_civicrm_mailing_event_opened_event_queue_id FOREIGN KEY (event_queue_id) REFERENCES civicrm_mailing_event_queue(id) ON DELETE CASCADE;

ALTER TABLE civicrm_mailing_event_reply
ADD CONSTRAINT FK_civicrm_mailing_event_reply_event_queue_id FOREIGN KEY (event_queue_id) REFERENCES civicrm_mailing_event_queue(id) ON DELETE CASCADE;

ALTER TABLE civicrm_mailing_event_trackable_url_open
ADD CONSTRAINT FK_civicrm_mailing_event_trackable_url_open_event_queue_id FOREIGN KEY (event_queue_id) REFERENCES civicrm_mailing_event_queue(id) ON DELETE CASCADE,
ADD CONSTRAINT FK_civicrm_mailing_event_trackable_url_open_trackable_url_id FOREIGN KEY (trackable_url_id) REFERENCES civicrm_mailing_trackable_url(id) ON DELETE CASCADE;

ALTER TABLE civicrm_mailing_event_unsubscribe
ADD CONSTRAINT FK_civicrm_mailing_event_unsubscribe_event_queue_id FOREIGN KEY (event_queue_id) REFERENCES civicrm_mailing_event_queue(id) ON DELETE CASCADE;

ALTER TABLE civicrm_pcp_block
ADD CONSTRAINT FK_civicrm_pcp_block_entity_id FOREIGN KEY (entity_id) REFERENCES civicrm_contribution_page(id) ,
ADD CONSTRAINT FK_civicrm_pcp_block_supporter_profile_id FOREIGN KEY (supporter_profile_id) REFERENCES civicrm_uf_group(id) ON DELETE SET NULL;

ALTER TABLE civicrm_membership_type
ADD CONSTRAINT FK_civicrm_membership_type_domain_id FOREIGN KEY (domain_id) REFERENCES civicrm_domain(id) ,
ADD CONSTRAINT FK_civicrm_membership_type_member_of_contact_id FOREIGN KEY (member_of_contact_id) REFERENCES civicrm_contact(id) ON DELETE RESTRICT,
ADD CONSTRAINT FK_civicrm_membership_type_contribution_type_id FOREIGN KEY (contribution_type_id) REFERENCES civicrm_contribution_type(id) ,
ADD CONSTRAINT FK_civicrm_membership_type_renewal_msg_id FOREIGN KEY (renewal_msg_id) REFERENCES civicrm_msg_template(id);
-- FK constraint fails (at least the FK_civicrm_membership_owner_membership_id key, possibly the ones after that)
ALTER TABLE civicrm_membership
ADD CONSTRAINT FK_civicrm_membership_contact_id FOREIGN KEY (contact_id) REFERENCES civicrm_contact(id) ON DELETE CASCADE,
ADD CONSTRAINT FK_civicrm_membership_membership_type_id FOREIGN KEY (membership_type_id) REFERENCES civicrm_membership_type(id) ON DELETE CASCADE,
ADD CONSTRAINT FK_civicrm_membership_status_id FOREIGN KEY (status_id) REFERENCES civicrm_membership_status(id) ON DELETE CASCADE,
ADD CONSTRAINT FK_civicrm_membership_owner_membership_id FOREIGN KEY (owner_membership_id) REFERENCES civicrm_membership(id) ON DELETE SET NULL,
ADD CONSTRAINT FK_civicrm_membership_contribution_recur_id FOREIGN KEY (contribution_recur_id) REFERENCES civicrm_contribution_recur(id) ON DELETE SET NULL,
ADD CONSTRAINT FK_civicrm_membership_campaign_id FOREIGN KEY (campaign_id) REFERENCES civicrm_campaign(id) ON DELETE SET NULL;

ALTER TABLE civicrm_membership_block
ADD CONSTRAINT FK_civicrm_membership_block_entity_id FOREIGN KEY (entity_id) REFERENCES civicrm_contribution_page(id) ,
ADD CONSTRAINT FK_civicrm_membership_block_membership_type_default FOREIGN KEY (membership_type_default) REFERENCES civicrm_membership_type(id);
-- FK constraint fails (at least the first one)
ALTER TABLE civicrm_membership_log
ADD CONSTRAINT FK_civicrm_membership_log_membership_id FOREIGN KEY (membership_id) REFERENCES civicrm_membership(id) ON DELETE CASCADE,
ADD CONSTRAINT FK_civicrm_membership_log_status_id FOREIGN KEY (status_id) REFERENCES civicrm_membership_status(id) ON DELETE CASCADE,
ADD CONSTRAINT FK_civicrm_membership_log_modified_id FOREIGN KEY (modified_id) REFERENCES civicrm_contact(id) ON DELETE SET NULL,
ADD CONSTRAINT FK_civicrm_membership_log_membership_type_id FOREIGN KEY (membership_type_id) REFERENCES civicrm_membership_type(id) ON DELETE SET NULL;

ALTER TABLE civicrm_price_field_value
ADD CONSTRAINT FK_civicrm_price_field_value_price_field_id FOREIGN KEY (price_field_id) REFERENCES civicrm_price_field(id) ,
ADD CONSTRAINT FK_civicrm_price_field_value_membership_type_id FOREIGN KEY (membership_type_id) REFERENCES civicrm_membership_type(id) ON DELETE SET NULL;

ALTER TABLE civicrm_line_item
ADD CONSTRAINT FK_civicrm_line_item_price_field_id FOREIGN KEY (price_field_id) REFERENCES civicrm_price_field(id) ON DELETE CASCADE,
ADD CONSTRAINT FK_civicrm_line_item_price_field_value_id FOREIGN KEY (price_field_value_id) REFERENCES civicrm_price_field_value(id) ON DELETE SET NULL;
-- FK constraint fails (at least the first one)
ALTER TABLE civicrm_address
ADD CONSTRAINT FK_civicrm_address_contact_id FOREIGN KEY (contact_id) REFERENCES civicrm_contact(id) ON DELETE CASCADE,
ADD CONSTRAINT FK_civicrm_address_county_id FOREIGN KEY (county_id) REFERENCES civicrm_county(id) ON DELETE SET NULL,
ADD CONSTRAINT FK_civicrm_address_state_province_id FOREIGN KEY (state_province_id) REFERENCES civicrm_state_province(id) ON DELETE SET NULL,
ADD CONSTRAINT FK_civicrm_address_country_id FOREIGN KEY (country_id) REFERENCES civicrm_country(id) ON DELETE SET NULL,
ADD CONSTRAINT FK_civicrm_address_master_id FOREIGN KEY (master_id) REFERENCES civicrm_address(id) ON DELETE SET NULL;

ALTER TABLE civicrm_loc_block
ADD CONSTRAINT FK_civicrm_loc_block_address_id FOREIGN KEY (address_id) REFERENCES civicrm_address(id) ON DELETE SET NULL,
ADD CONSTRAINT FK_civicrm_loc_block_email_id FOREIGN KEY (email_id) REFERENCES civicrm_email(id) ON DELETE SET NULL,
ADD CONSTRAINT FK_civicrm_loc_block_phone_id FOREIGN KEY (phone_id) REFERENCES civicrm_phone(id) ON DELETE SET NULL,
ADD CONSTRAINT FK_civicrm_loc_block_im_id FOREIGN KEY (im_id) REFERENCES civicrm_im(id) ON DELETE SET NULL,
ADD CONSTRAINT FK_civicrm_loc_block_address_2_id FOREIGN KEY (address_2_id) REFERENCES civicrm_address(id) ON DELETE SET NULL,
ADD CONSTRAINT FK_civicrm_loc_block_email_2_id FOREIGN KEY (email_2_id) REFERENCES civicrm_email(id) ON DELETE SET NULL,
ADD CONSTRAINT FK_civicrm_loc_block_phone_2_id FOREIGN KEY (phone_2_id) REFERENCES civicrm_phone(id) ON DELETE SET NULL,
ADD CONSTRAINT FK_civicrm_loc_block_im_2_id FOREIGN KEY (im_2_id) REFERENCES civicrm_im(id) ON DELETE SET NULL;
-- FK constraint fails (at least the 2nd one, possibly the remaining ones too)
ALTER TABLE civicrm_group_contact
ADD CONSTRAINT FK_civicrm_group_contact_group_id FOREIGN KEY (group_id) REFERENCES civicrm_group(id) ON DELETE CASCADE,
ADD CONSTRAINT FK_civicrm_group_contact_contact_id FOREIGN KEY (contact_id) REFERENCES civicrm_contact(id) ON DELETE CASCADE,
ADD CONSTRAINT FK_civicrm_group_contact_location_id FOREIGN KEY (location_id) REFERENCES civicrm_loc_block(id) ON DELETE SET NULL,
ADD CONSTRAINT FK_civicrm_group_contact_email_id FOREIGN KEY (email_id) REFERENCES civicrm_email(id);
-- FK constraint fails (at least the first one)
ALTER TABLE civicrm_contribution
ADD CONSTRAINT FK_civicrm_contribution_contact_id FOREIGN KEY (contact_id) REFERENCES civicrm_contact(id) ON DELETE CASCADE,
ADD CONSTRAINT FK_civicrm_contribution_contribution_type_id FOREIGN KEY (contribution_type_id) REFERENCES civicrm_contribution_type(id) ON DELETE SET NULL,
ADD CONSTRAINT FK_civicrm_contribution_contribution_page_id FOREIGN KEY (contribution_page_id) REFERENCES civicrm_contribution_page(id) ON DELETE SET NULL,
ADD CONSTRAINT FK_civicrm_contribution_contribution_recur_id FOREIGN KEY (contribution_recur_id) REFERENCES civicrm_contribution_recur(id) ON DELETE SET NULL,
ADD CONSTRAINT FK_civicrm_contribution_honor_contact_id FOREIGN KEY (honor_contact_id) REFERENCES civicrm_contact(id) ON DELETE SET NULL,
ADD CONSTRAINT FK_civicrm_contribution_address_id FOREIGN KEY (address_id) REFERENCES civicrm_address(id) ON DELETE SET NULL,
ADD CONSTRAINT FK_civicrm_contribution_campaign_id FOREIGN KEY (campaign_id) REFERENCES civicrm_campaign(id) ON DELETE SET NULL;
-- FK constraint fails
ALTER TABLE civicrm_contribution_product
ADD CONSTRAINT FK_civicrm_contribution_product_contribution_id FOREIGN KEY (contribution_id) REFERENCES civicrm_contribution(id) ON DELETE CASCADE;
-- FK constraint fails (at least the first one)
ALTER TABLE civicrm_contribution_soft
ADD CONSTRAINT FK_civicrm_contribution_soft_contribution_id FOREIGN KEY (contribution_id) REFERENCES civicrm_contribution(id) ON DELETE CASCADE,
ADD CONSTRAINT FK_civicrm_contribution_soft_contact_id FOREIGN KEY (contact_id) REFERENCES civicrm_contact(id) ON DELETE CASCADE,
ADD CONSTRAINT FK_civicrm_contribution_soft_pcp_id FOREIGN KEY (pcp_id) REFERENCES civicrm_pcp(id) ON DELETE SET NULL;
-- FK constraint fails (just the second one)
ALTER TABLE civicrm_membership_payment
ADD CONSTRAINT FK_civicrm_membership_payment_membership_id FOREIGN KEY (membership_id) REFERENCES civicrm_membership(id) ON DELETE CASCADE,
ADD CONSTRAINT FK_civicrm_membership_payment_contribution_id FOREIGN KEY (contribution_id) REFERENCES civicrm_contribution(id) ON DELETE CASCADE;

ALTER TABLE civicrm_event
ADD CONSTRAINT FK_civicrm_event_payment_processor_id FOREIGN KEY (payment_processor_id) REFERENCES civicrm_payment_processor(id) ON DELETE SET NULL,
ADD CONSTRAINT FK_civicrm_event_loc_block_id FOREIGN KEY (loc_block_id) REFERENCES civicrm_loc_block(id) ON DELETE SET NULL,
ADD CONSTRAINT FK_civicrm_event_created_id FOREIGN KEY (created_id) REFERENCES civicrm_contact(id) ON DELETE SET NULL,
ADD CONSTRAINT FK_civicrm_event_campaign_id FOREIGN KEY (campaign_id) REFERENCES civicrm_campaign(id) ON DELETE SET NULL;
-- FK constraint fails (at least discount_id, possibly followers)
ALTER TABLE civicrm_participant
ADD CONSTRAINT FK_civicrm_participant_contact_id FOREIGN KEY (contact_id) REFERENCES civicrm_contact(id) ON DELETE CASCADE,
ADD CONSTRAINT FK_civicrm_participant_event_id FOREIGN KEY (event_id) REFERENCES civicrm_event(id) ON DELETE CASCADE,
ADD CONSTRAINT FK_civicrm_participant_status_id FOREIGN KEY (status_id) REFERENCES civicrm_participant_status_type(id) ,
ADD CONSTRAINT FK_civicrm_participant_registered_by_id FOREIGN KEY (registered_by_id) REFERENCES civicrm_participant(id) ON DELETE SET NULL,
ADD CONSTRAINT FK_civicrm_participant_discount_id FOREIGN KEY (discount_id) REFERENCES civicrm_discount(id) ON DELETE SET NULL,
ADD CONSTRAINT FK_civicrm_participant_campaign_id FOREIGN KEY (campaign_id) REFERENCES civicrm_campaign(id) ON DELETE SET NULL;
-- FK constraint fails (at least the first one)
ALTER TABLE civicrm_participant_payment
ADD CONSTRAINT FK_civicrm_participant_payment_participant_id FOREIGN KEY (participant_id) REFERENCES civicrm_participant(id) ON DELETE CASCADE,
ADD CONSTRAINT FK_civicrm_participant_payment_contribution_id FOREIGN KEY (contribution_id) REFERENCES civicrm_contribution(id) ON DELETE CASCADE;

ALTER TABLE civicrm_pledge_payment
ADD CONSTRAINT FK_civicrm_pledge_payment_pledge_id FOREIGN KEY (pledge_id) REFERENCES civicrm_pledge(id) ON DELETE CASCADE,
ADD CONSTRAINT FK_civicrm_pledge_payment_contribution_id FOREIGN KEY (contribution_id) REFERENCES civicrm_contribution(id) ON DELETE CASCADE;
