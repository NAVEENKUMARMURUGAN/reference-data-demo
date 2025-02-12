# Reference Data Management with Liquibase

A systematic approach to manage reference data (like currency rates) using Liquibase, focusing on versioning and temporal data management.

## Quick Start

### Setup and Run

```bash
# Remove containers and volumes
docker compose down -v

# Start Postgres
docker compose up -d postgres

# Run Liquibase
docker compose up liquibase
```

### Common Commands

```bash
# Apply changes
docker compose run --rm liquibase \
 --changelog-file=changelog/db.changelog_master.xml \
 update

# Check status
docker compose run --rm liquibase \
 --changelog-file=changelog/db.changelog_master.xml \
 status

# View history
docker compose run --rm liquibase \
 --changelog-file=changelog/db.changelog_master.xml \
 history

# Rollback one version
docker compose run --rm liquibase \
 --changelog-file=changelog/db.changelog_master.xml \
 rollbackCount 1

# Reapply after rollback
docker compose run --rm liquibase \
 --changelog-file=changelog/db.changelog_master.xml \
 update
```

## Project Structure

```
changelog/
├── db.changelog_master.xml              # Master changelog
└── reference_data/
    └── currency_rates/                  # Currency reference data
        ├── schema/                      # Database definitions
        │   ├── 001_create_table.sql    # Table creation
        │   ├── 001_create_table.xml    # Liquibase wrapper
        │   └── 001_drop_table.sql      # Rollback script
        └── data/                        # Version-wise changes
            ├── v1/                      # Initial data
            ├── v2/                      # Version 2 changes
            ├── v3/                      # Version 3 changes
            └── v4/                      # Version 4 changes
```

## Features

### Version Control

- Each data change gets a new version number
- Version numbers must be sequential
- Prevents duplicate versions
- Validates version existence

### Temporal Tracking

- Records when changes become effective (effective_date)
- Tracks when records expire (expiry_date)
- Maintains history of all changes

### Change Management

1. **Initial Load (v1)**

   - Loads initial set of currencies
   - No temporal tracking needed

2. **Updates (v2-v4)**
   - End-dates previous version records
   - Inserts new version records
   - Handles additions, updates, and deletions

### Rollback Support

- Each change can be rolled back
- Restores previous version's state
- Maintains data integrity

### Validation Rules

- Version numbers must be sequential
- Previous version must exist
- New version must not exist
- Currency codes must be unique per version

## Usage

### Adding New Version

1. Create new directory `vX/` under data/
2. Create CSV file with new data:
   ```csv
   currency_code,rate,decimals,description
   USD,1.0000,2,"United States Dollar"
   EUR,1.1000,2,"Euro"
   ```
3. Copy and modify load XML file:
   ```xml
   <property name="prev.version.number" value="X-1" global="false"/>
   <property name="version.number" value="X" global="false"/>
   ```
4. Update version numbers
5. Add to master changelog

### Querying Data

```sql
-- Get current active records
SELECT * FROM currency_rates
WHERE expiry_date = '9999-12-31';

-- Get historical records for a date
SELECT * FROM currency_rates
WHERE effective_date <= 'YYYY-MM-DD'
  AND expiry_date > 'YYYY-MM-DD';
```

## Rollback Process

Each version can be rolled back by:

1. Removing records of current version
2. Restoring expiry dates of previous version
3. Maintaining data integrity

## Best Practices

1. Always include version validation
2. Use proper version numbering
3. Maintain CSV format consistency
4. Include clear descriptions
5. Test rollback scenarios

## Database Schema

```sql
CREATE TABLE currency_rates (
    currency_code VARCHAR(3),
    rate DECIMAL(10,4) NOT NULL,
    decimals INT NOT NULL,
    description TEXT,
    effective_date DATE NOT NULL DEFAULT CURRENT_DATE,
    expiry_date DATE NULL DEFAULT '9999-12-31',
    deployment_version VARCHAR(100) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NOT NULL DEFAULT 'Credit Strategy team',
    CONSTRAINT valid_date_range CHECK (expiry_date >= effective_date),
    CONSTRAINT unique_currency_version UNIQUE (currency_code, deployment_version),
    PRIMARY KEY (currency_code, deployment_version)
);
```
