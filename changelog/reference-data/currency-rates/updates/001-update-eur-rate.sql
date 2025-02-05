UPDATE currency_rates 
SET rate = 1.1500,
    updated_at = CURRENT_TIMESTAMP,
    created_by = 'business-update-001'
WHERE currency_code = 'EUR';