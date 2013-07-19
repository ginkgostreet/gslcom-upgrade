-- see http://wiki.civicrm.org/confluence/display/CRMDOC/Clean+up+extraneous+financial+data+-+4.3+upgrades
DELETE entity_financial_trxn_financial, financial_item, entity_financial_trxn, financial_trxn
FROM civicrm_financial_trxn financial_trxn
LEFT JOIN civicrm_entity_financial_trxn entity_financial_trxn
  ON entity_financial_trxn.financial_trxn_id = financial_trxn.id
  AND entity_financial_trxn.entity_table = 'civicrm_contribution'
LEFT JOIN civicrm_entity_financial_trxn entity_financial_trxn_financial
  ON entity_financial_trxn_financial.financial_trxn_id = financial_trxn.id
  AND entity_financial_trxn_financial.entity_table = 'civicrm_financial_item'
LEFT JOIN civicrm_financial_item financial_item
  ON entity_financial_trxn_financial.entity_table = 'civicrm_financial_item'
  AND financial_item.id = entity_financial_trxn_financial.entity_id
LEFT JOIN civicrm_contribution contribution
  ON contribution.id = entity_financial_trxn.entity_id
  AND entity_financial_trxn.entity_table = 'civicrm_contribution'
WHERE contribution.id IS NULL;

DELETE line_item
FROM civicrm_line_item line_item
LEFT JOIN civicrm_contribution contribution
  ON line_item.entity_id = contribution.id
  AND line_item.entity_table = 'civicrm_contribution'
LEFT JOIN civicrm_participant participant
  ON line_item.entity_id = participant.id
  AND line_item.entity_table = 'civicrm_participant'
WHERE CASE WHEN line_item.entity_table = 'civicrm_contribution'
  THEN contribution.id IS NULL
  ELSE  participant.id IS NULL
END;

DELETE financial_item
FROM civicrm_financial_item financial_item
LEFT JOIN civicrm_entity_financial_trxn entity_financial_trxn
  ON entity_financial_trxn.entity_table = 'civicrm_financial_item'
  AND financial_item.id = entity_financial_trxn.entity_id
WHERE entity_financial_trxn.entity_id IS NULL;