FROM centos:7
MAINTAINER Marcos Entenza <mak@redhat.com>

RUN yum update -y && \
yum install -y make gcc rubygems && yum clean all

RUN gem install redis

RUN mkdir /usr/local/bin && \
mkdir /usr/local/etc && \

WORKDIR /usr/local/src/

RUN curl -o redis-3.2.6.tar.gz http://download.redis.io/releases/redis-3.2.6.tar.gz && \
tar xzf redis-3.2.6.tar.gz && \
cd redis-3.2.6 && \
make MALLOC=libc

RUN for file in $(grep -r --exclude=*.h --exclude=*.o /usr/local/src/redis-3.2.6/src | awk {'print $3'}); do cp $file /usr/local/bin; done && \
cp /usr/local/src/redis-3.2.6/src/redis-trib.rb /usr/local/bin

COPY src/redis-cluster-node01.conf /usr/local/etc/redis.conf

EXPOSE 6381

CMD [ "redis-server", "/usr/local/etc/redis.conf" ]
