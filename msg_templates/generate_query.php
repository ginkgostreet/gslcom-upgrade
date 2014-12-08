#! /usr/bin/env php

<?php
/**
 * This scripts accepts two arguments:
 *  - a string which is the name for the database
 *  - an integer which is the ID of the message template to be updated
 */

$format = 'UPDATE `%s`.`civicrm_msg_template` SET `msg_text` = "%s", `msg_html` = "%s" WHERE id = %d';

// yes we are being lazy and doing no validation
$db_name = $argv[1];
$id = (int) $argv[2];

// grab content from specially-named files
$html = file_get_contents(dirname(__FILE__) . "/{$id}.html");
$text = file_get_contents(dirname(__FILE__) . "/{$id}.txt");

// escape the content for MySQL
$html = mysql_escape_string($html);
$text = mysql_escape_string($text);

printf ($format, $db_name, $text, $html, $id);