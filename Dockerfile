FROM python:2.7.13-alpine3.6
 
# 1-2. Install system dependencies (we only need the pg_dump binary from postgresql, other dependencies are in postgresql-client)
RUN apk add --no-cache postgresql-client && \
    apk add --no-cache --virtual BUIID_DEPS postgresql && \
    apk add --no-cache bash && \
    cp /usr/bin/pg_dump /bin/pg_dump && cp /usr/bin/pg_dumpall /bin/pg_dumpall && \
    apk del BUIID_DEPS

WORKDIR /root/

# Add scripts
ADD pg_backup.config ./
ADD pg_backup_rotated.sh ./
RUN chmod +x ./pg_backup_rotated.sh

# Add cron
ADD crontab crontab 
RUN /usr/bin/crontab crontab
RUN rm crontab

# We run cron in foreground to update the certificates
CMD ["/usr/sbin/crond", "-f"]
