docker compose down -v

docker compose up -d postgres

docker compose up liquibase

Apply changes

docker compose run --rm liquibase \
 --changelog-file=changelog/db.changelog_master.xml \
 update

check status
docker compose run --rm liquibase \
 --changelog-file=changelog/db.changelog_master.xml \
 status

check history
docker compose run --rm liquibase \
 --changelog-file=changelog/db.changelog_master.xml \
 history

rollback
docker compose run --rm liquibase \
 --changelog-file=changelog/db.changelog_master.xml \
 rollbackCount 1

# Reapply all changes after rollback

docker compose run --rm liquibase \
 --changelog-file=changelog/db.changelog_master.xml \
 update

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

## Usage

### Adding New Version

1. Create new directory `vX/` under data/
2. Create CSV file with new data
3. Copy and modify load XML file
4. Update version numbers
5. Add to master changelog

### CSV Format

```csv
currency_code,rate,decimals,description
USD,1.0000,2,"United States Dollar"
EUR,1.1000,2,"Euro"
```
