# PGdumper setup for Docker

A very simple image that makes dumps from a Postgres service using `pg_backup_rotated.sh`, to be used in conjunction with a backup service. [Docker hub repository](https://hub.docker.com/r/olivierdalang/pgdumper/).

## Example

In your `docker-compose.yml`:

```yaml
services:

  ...

  # PostGIS database.
  postgres:
    image: mdillon/postgis:9.6-alpine
    volumes:
      - database:/var/lib/postgresql/data/
    restart: always

  # add the pgdumper service
  pgdumper:
    build: ./pgdumper/
    volumes:
      - pgdumps:/pgdumps/
    restart: always

# volumes definition
volumes:
  ...
  pgdumps:
```
