FROM python:2.7.13-alpine3.6
 
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
ADD pg_backup.config ./
ADD pg_backup_rotated.sh ./
RUN chmod +x ./pg_backup_rotated.sh

# We run cron in foreground to run the cronfile
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/sbin/crond", "-f"]
