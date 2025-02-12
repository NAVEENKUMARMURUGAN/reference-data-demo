-- schema/001-create-table.sql
-- Drop if exists
DROP TABLE IF EXISTS currency_rates;

-- Create table
CREATE TABLE currency_rates (
    currency_code VARCHAR(3),
    rate DECIMAL(10,4) NOT NULL,
    decimals INT NOT NULL,
    description TEXT,
    effective_date DATE NOT NULL DEFAULT CURRENT_DATE,
    expiry_date DATE NULL DEFAULT '9999-12-31',
    deployment_version VARCHAR(100) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NOT NULL DEFAULT 'Currency Rates team', 
    CONSTRAINT valid_date_range CHECK (expiry_date >= effective_date),
    CONSTRAINT unique_currency_version UNIQUE (currency_code, deployment_version),
    PRIMARY KEY (currency_code, deployment_version)
);