CREATE TABLE `civicrm_setting` (


     `id` int unsigned NOT NULL AUTO_INCREMENT  ,
     `group_name` varchar(64) NOT NULL   COMMENT 'group name for setting element, useful in caching setting elements',
     `name` varchar(255)    COMMENT 'Unique name for setting',
     `value` text    COMMENT 'data associated with this group / name combo',
     `domain_id` int unsigned NOT NULL   COMMENT 'Which Domain is this menu item for',
     `contact_id` int unsigned    COMMENT 'FK to Contact ID if the setting is localized to a contact',
     `is_domain` tinyint    COMMENT 'Is this setting a contact specific or site wide setting?',
     `component_id` int unsigned    COMMENT 'Component that this menu item belongs to',
     `created_date` datetime    COMMENT 'When was the setting created',
     `created_id` int unsigned    COMMENT 'FK to civicrm_contact, who created this setting'
,
    PRIMARY KEY ( `id` )

    ,     INDEX `index_group_name`(
        `group_name`
      , `name`
  )

,
     CONSTRAINT FK_civicrm_setting_domain_id FOREIGN KEY (`domain_id`) REFERENCES `civicrm_domain`(`id`) ON DELETE CASCADE,
     CONSTRAINT FK_civicrm_setting_contact_id FOREIGN KEY (`contact_id`) REFERENCES `civicrm_contact`(`id`) ON DELETE CASCADE,
     CONSTRAINT FK_civicrm_setting_component_id FOREIGN KEY (`component_id`) REFERENCES `civicrm_component`(`id`) ,
     CONSTRAINT FK_civicrm_setting_created_id FOREIGN KEY (`created_id`) REFERENCES `civicrm_contact`(`id`) ON DELETE SET NULL
)  ENGINE=InnoDB DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci  ;
