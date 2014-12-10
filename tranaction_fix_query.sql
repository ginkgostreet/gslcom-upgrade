-- This is a mysql script to fix trasactions missing a payment instrument for CiviCRM upgrade  

-- Beginning of script

-- Query to fix the transactions 

UPDATE civicrm_financial_trxn ft  INNER JOIN
(SELECT sq1.to_financial_account_id, sq2.first_non_null FROM
(SELECT eftc.entity_id AS contribution_id, max(ft.id) AS last_null, ft.to_financial_account_id FROM civicrm_financial_trxn ft INNER JOIN civicrm_entity_financial_trxn eftc ON eftc.financial_trxn_id=ft.id AND eftc.entity_table='civicrm_contribution' WHERE ft.payment_instrument_id IS NULL GROUP BY contribution_id) AS sq1
INNER JOIN
(SELECT eftc.entity_id AS contribution_id, min(ft.id) AS first_non_null, ft.from_financial_account_id FROM civicrm_financial_trxn ft INNER JOIN civicrm_entity_financial_trxn eftc ON eftc.financial_trxn_id=ft.id AND eftc.entity_table='civicrm_contribution' WHERE ft.payment_instrument_id IS NOT NULL GROUP BY contribution_id) AS sq2
ON sq1.contribution_id=sq2.contribution_id
LEFT JOIN civicrm_contribution cc ON cc.id  = sq1.contribution_id
LEFT JOIN civicrm_entity_batch ceb ON sq2.first_non_null = ceb.entity_id AND ceb.entity_table = 'civicrm_financial_trxn'
LEFT JOIN civicrm_batch cb ON cb.id = ceb.batch_id
LEFT JOIN civicrm_option_value cov ON  cb.status_id = cov.value AND cov.name IN ('Closed', 'Data Entry', 'Reopened', 'Open') AND cov.option_group_id = (SELECT id FROM  civicrm_option_group WHERE name = 'batch_status')
WHERE sq1.to_financial_account_id <> sq2.from_financial_account_id AND (cov.name <> 'Exported' OR cb.id IS NULL))
newft ON  newft.first_non_null = ft.id
SET ft.from_financial_account_id = newft.to_financial_account_id;

-- Queries to fix the transactions that relate to contributions that had a null payment instrument but that were edited so it became non-null

-- First, get the payment_instrument that will be used instead of null

SELECT  @check_value := value FROM  civicrm_option_value cov
INNER JOIN civicrm_option_group cog ON cog.id = cov.option_group_id
WHERE cog.name = 'payment_instrument' AND cov.name = 'Check';

-- Now replace the null payment instruments to the one just set

UPDATE civicrm_financial_trxn cft
LEFT JOIN civicrm_entity_financial_trxn ceft ON ceft.financial_trxn_id = cft.id
LEFT JOIN civicrm_contribution cc  ON ceft.entity_id = cc.id
SET cc.payment_instrument_id = IFNULL(cc.payment_instrument_id, @check_value),
cft.payment_instrument_id = @check_value
WHERE ceft.entity_table = 'civicrm_contribution' AND cft.payment_instrument_id IS NULL;
