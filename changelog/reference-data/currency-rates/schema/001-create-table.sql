-- schema/001-create-table.sql
CREATE TABLE currency_rates (
    currency_code VARCHAR(3),
    rate DECIMAL(10,4) NOT NULL,
    decimals INT NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    description TEXT,
    effective_from TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    effective_to TIMESTAMP NULL,
    created_by VARCHAR(100),
    PRIMARY KEY (currency_code, effective_from)
);