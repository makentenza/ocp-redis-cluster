FROM redis
MAINTAINER Marcos Entenza <mak@redhat.com>

COPY src/redis-cluster-node02.conf /usr/local/etc/redis/redis.conf

EXPOSE 6382

CMD [ "redis-server", "/usr/local/etc/redis/redis.conf" ]
