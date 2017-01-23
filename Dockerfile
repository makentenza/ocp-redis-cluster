FROM redis:3.2.6
MAINTAINER Marcos Entenza <mak@redhat.com>

COPY src/redis.conf /usr/local/etc/redis/redis.conf
COPY src/fix-permissions /usr/local/bin/

RUN chmod +x /usr/local/bin/fix-permissions && \
/usr/local/bin/fix-permissions /data && \
/usr/local/bin/fix-permissions /usr/local/bin


CMD [ "redis-server", "/usr/local/etc/redis/redis.conf" ]
