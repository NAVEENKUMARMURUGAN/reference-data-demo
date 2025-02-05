-- File: reference-data/currency-rates/schema/001-create-table.sql
-- Drop if exists
DROP TABLE IF EXISTS currency_rates;

-- Create table
CREATE TABLE currency_rates (
    currency_code VARCHAR(3) PRIMARY KEY,
    rate DECIMAL(10,4) NOT NULL,
    decimals INT NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    description TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(100)
);

--rollback DROP TABLE IF EXISTS currency_rates;