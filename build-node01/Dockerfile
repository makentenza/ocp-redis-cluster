FROM redis
MAINTAINER Marcos Entenza <mak@redhat.com>

COPY src/redis-cluster-node01.conf /usr/local/etc/redis/redis.conf

EXPOSE 6381

CMD [ "redis-server", "/usr/local/etc/redis/redis.conf" ]
