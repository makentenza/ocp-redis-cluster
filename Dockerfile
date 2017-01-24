FROM centos:7
MAINTAINER Marcos Entenza <mak@redhat.com>

RUN groupadd -r redis && useradd -r -g redis redis

RUN yum update -y && \
yum install -y make gcc rubygems && yum clean all && \
mkdir /usr/local/etc

RUN gem install redis

WORKDIR /usr/local/src/

RUN curl -o redis-3.2.6.tar.gz http://download.redis.io/releases/redis-3.2.6.tar.gz && \
tar xzf redis-3.2.6.tar.gz && \
cd redis-3.2.6 && \
make MALLOC=libc

RUN for file in $(grep -r --exclude=*.h --exclude=*.o /usr/local/src/redis-3.2.6/src | awk {'print $3'}); do cp $file /usr/local/bin; done && \
cp /usr/local/src/redis-3.2.6/src/redis-trib.rb /usr/local/bin && \
rm -rf /usr/local/src/redis*

COPY src/redis-cluster-node01.conf /usr/local/etc/redis.conf
COPY src/*.sh /usr/local/bin/


RUN mkdir /data && chown redis:redis /data
VOLUME /data
WORKDIR /data

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 6379

CMD [ "redis-server", "/usr/local/etc/redis.conf" ]
