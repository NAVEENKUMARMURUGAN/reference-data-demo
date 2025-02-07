-- schema/001-create-table.sql
-- Drop if exists
DROP TABLE IF EXISTS currency_rates;

-- Create table
CREATE TABLE currency_rates (
    currency_code VARCHAR(3),
    rate DECIMAL(10,4) NOT NULL,
    decimals INT NOT NULL,
    description TEXT,
    effective_from DATE NOT NULL DEFAULT CURRENT_DATE,
    effective_to DATE NULL DEFAULT '9999-12-31',
    deployment_version VARCHAR(100) NOT NULL,
    PRIMARY KEY (currency_code, deployment_version)
);