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
