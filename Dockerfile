FROM alpine:3.13

# Default config
# (see pg_backup.config for detailed explanations)
ENV BACKUP_USER=
ENV HOSTNAME=postgres
ENV USERNAME=postgres
ENV BACKUP_DIR=/pgdumps/
ENV SCHEMA_ONLY_LIST="postgres"
ENV ENABLE_CUSTOM_BACKUPS=yes
ENV ENABLE_PLAIN_BACKUPS=yes
ENV DAY_OF_WEEK_TO_KEEP=5
ENV DAYS_TO_KEEP=7
ENV WEEKS_TO_KEEP=5
 
# 1-2. Install system dependencies (we only need the pg_dump binary from postgresql, other dependencies are in postgresql-client)
RUN apk add --no-cache postgresql-client && \
    apk add --no-cache --virtual BUIID_DEPS postgresql && \
    apk add --no-cache bash && \
    cp /usr/bin/pg_dump /bin/pg_dump && cp /usr/bin/pg_dumpall /bin/pg_dumpall && \
    apk del BUIID_DEPS

WORKDIR /root/

# Add entrypoint
ADD docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# Add scripts
ADD pg_backup_rotated.sh ./
RUN chmod +x ./pg_backup_rotated.sh

# We run cron in foreground to run the cronfile
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/sbin/crond", "-f"]
