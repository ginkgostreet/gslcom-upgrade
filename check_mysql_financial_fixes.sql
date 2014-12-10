-- This mysql script is to check if the transactions missing a payment instrument's query/fix, worked properly 

-- Beginning of script

-- Query to show financial transaction with payment instrument = NULL

SELECT cc.id contribution_id, cc.contact_id, cft.id financial_trxn_id, cft.total_amount, cc.receive_date, 
cc.contribution_status_id, cc.financial_type_id, cb.title batch_title, cov.label batch_status
FROM civicrm_financial_trxn cft
LEFT JOIN civicrm_entity_financial_trxn ceft ON ceft.financial_trxn_id = cft.id
LEFT JOIN civicrm_contribution cc  ON ceft.entity_id = cc.id
LEFT JOIN civicrm_entity_batch ceb ON cft.id = ceb.entity_id AND ceb.entity_table = 'civicrm_financial_trxn'
LEFT JOIN civicrm_batch cb ON cb.id = ceb.batch_id
LEFT JOIN civicrm_option_value cov ON  cb.status_id = cov.value AND cov.name IN ('Closed', 'Data Entry', 'Reopened', 'Open') AND cov.option_group_id = (SELECT id FROM  civicrm_option_group WHERE name = 'batch_status')
WHERE ceft.entity_table = 'civicrm_contribution'  AND cft.payment_instrument_id IS NULL AND (cov.name <> 'Exported' OR cb.id IS NULL);


-- Query to show financial transaction that has wrong from_financial_account_id stored while changing payment_instrument from Null to Non-Null

SELECT cc.id contribution_id, cc.contact_id, sq2.first_non_null financial_trxn_id, sq2.total_amount, cc.receive_date, cc.contribution_status_id, cc.financial_type_id, cb.title batch_title, cov.label batch_status
FROM

(SELECT eftc.entity_id AS contribution_id, max(ft.id) AS last_null, ft.to_financial_account_id FROM civicrm_financial_trxn ft INNER JOIN civicrm_entity_financial_trxn eftc ON eftc.financial_trxn_id=ft.id AND eftc.entity_table='civicrm_contribution' WHERE ft.payment_instrument_id IS NULL GROUP BY contribution_id) AS sq1

INNER JOIN

(SELECT eftc.entity_id AS contribution_id, min(ft.id) AS first_non_null, ft.from_financial_account_id, ft.total_amount FROM civicrm_financial_trxn ft INNER JOIN civicrm_entity_financial_trxn eftc ON eftc.financial_trxn_id=ft.id AND eftc.entity_table='civicrm_contribution' WHERE ft.payment_instrument_id IS NOT NULL GROUP BY contribution_id) AS sq2

ON sq1.contribution_id=sq2.contribution_id

LEFT JOIN civicrm_contribution cc ON cc.id  = sq1.contribution_id

LEFT JOIN civicrm_entity_batch ceb ON sq2.first_non_null = ceb.entity_id AND ceb.entity_table = 'civicrm_financial_trxn'

LEFT JOIN civicrm_batch cb ON cb.id = ceb.batch_id

LEFT JOIN civicrm_option_value cov ON  cb.status_id = cov.value AND cov.name IN ('Closed', 'Data Entry', 'Reopened', 'Open') AND cov.option_group_id = (SELECT id FROM  civicrm_option_group WHERE name = 'batch_status')

WHERE sq1.to_financial_account_id <> sq2.from_financial_account_id AND (cov.name <> 'Exported' OR cb.id IS NULL);
