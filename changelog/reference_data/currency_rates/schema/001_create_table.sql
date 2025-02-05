-- schema/001-create-table.sql
-- Drop if exists
DROP TABLE IF EXISTS currency_rates;

-- Create table
CREATE TABLE currency_rates (
    currency_code VARCHAR(3),
    rate DECIMAL(10,4) NOT NULL,
    decimals INT NOT NULL,
    description TEXT,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    effective_from TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    effective_to TIMESTAMP NULL,
    created_by_deployment_version VARCHAR(100),
    PRIMARY KEY (currency_code, effective_from)
);