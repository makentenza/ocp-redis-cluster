FROM redis:3.2.6
MAINTAINER Marcos Entenza <mak@redhat.com>

COPY src/redis.conf /usr/local/etc/redis/redis.conf


CMD [ "redis-server", "/usr/local/etc/redis/redis.conf" ]
