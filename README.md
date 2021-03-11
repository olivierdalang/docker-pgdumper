# PGdumper setup for Docker

A very simple image that makes dumps from a Postgres service using `pg_backup_rotated.sh`, to be used in conjunction with a backup service. [Docker hub repository](https://hub.docker.com/r/olivierdalang/pgdumper/).

## Example

In your `docker-compose.yml`:

```yaml
services:

  ...

  # PostGIS database.
  dbservice:
    image: mdillon/postgis:9.6-alpine
    volumes:
      - database:/var/lib/postgresql/data/
    restart: unless-stopped

  # add the pgdumper service
  pgdumper:
    build: ./pgdumper/
    volumes:
      - pgdumps:/pgdumps/
    environment:
      - HOSTNAME=dbservice
    restart: unless-stopped

# volumes definition
volumes:
  ...
  pgdumps:
```

Set `HOSTNAME` to the name of your postgres service.

The options are described in the original pg_backup.config file below.
All these settings can be set using environment variables.

Additionnaly, you can provide a password (if needed) with the `PGPASSWORD` env var.

```
# taken from pg_backup.config

##############################
## POSTGRESQL BACKUP CONFIG ##
##############################
 
# Optional system user to run backups as.  If the user the script is running as doesn't match this
# the script terminates.  Leave blank to skip check.
BACKUP_USER=
 
# Optional hostname to adhere to pg_hba policies.  Will default to "localhost" if none specified.
HOSTNAME=postgres
 
# Optional username to connect to database as.  Will default to "postgres" if none specified.
USERNAME=postgres

# This dir will be created if it doesn't exist.  This must be writable by the user the script is
# running as.
BACKUP_DIR=/pgdumps/

# List of strings to match against in database name, separated by space or comma, for which we only
# wish to keep a backup of the schema, not the data. Any database names which contain any of these
# values will be considered candidates. (e.g. "system_log" will match "dev_system_log_2010-01")
SCHEMA_ONLY_LIST="postgres"
 
# Will produce a custom-format backup if set to "yes"
ENABLE_CUSTOM_BACKUPS=yes
 
# Will produce a gzipped plain-format backup if set to "yes"
ENABLE_PLAIN_BACKUPS=yes
 
 
#### SETTINGS FOR ROTATED BACKUPS ####
 
# Which day to take the weekly backup from (1-7 = Monday-Sunday)
DAY_OF_WEEK_TO_KEEP=5
 
# Number of days to keep daily backups
DAYS_TO_KEEP=7
 
# How many weeks to keep weekly backups
WEEKS_TO_KEEP=5
 
######################################
```

## Changelog

- 0.1.1 : create the backup directory to avoid failure if it does not exist
- 0.1 : creates a "latest" dump (so you can restore latest version from a constant path)
- 0.0.1 : initial release