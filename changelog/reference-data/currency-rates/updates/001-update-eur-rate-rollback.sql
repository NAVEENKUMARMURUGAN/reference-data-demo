UPDATE currency_rates 
SET rate = 1.1000,
    updated_at = CURRENT_TIMESTAMP,
    created_by = 'rollback-001'
WHERE currency_code = 'EUR';