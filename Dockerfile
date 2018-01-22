FROM centos:7
MAINTAINER Marcos Entenza <mak@redhat.com>

LABEL io.k8s.description="3 Node Redis Cluster" \
      io.k8s.display-name="Redis Cluster" \
      io.openshift.expose-services="6379:tcp" \
      io.openshift.tags="redis-cluster"

ENV PATH="/usr/local/rvm/rubies/ruby-2.4.1/bin:${PATH}"

RUN groupadd -r redis && useradd -r -g redis -d /home/redis -m redis

RUN yum update -y && \
yum install -y gcc-c++ patch readline readline-devel zlib zlib-devel libyaml-devel libffi-devel openssl-devel make \
    bzip2 autoconf automake libtool bison iconv-devel sqlite-devel which && \
yum clean all

RUN curl -sSL https://rvm.io/mpapis.asc | gpg --import - && \
curl -L get.rvm.io | bash -s stable && \
source /etc/profile.d/rvm.sh && \
/usr/local/rvm/bin/rvm reload && \
/usr/local/rvm/bin/rvm requirements run && \
/usr/local/rvm/bin/rvm install 2.4 && \
/usr/local/rvm/bin/rvm use 2.4 --default

RUN echo "151.101.64.70 rubygems.org">> /etc/hosts && \
gem install redis

WORKDIR /usr/local/src/

RUN curl -o redis-3.2.6.tar.gz http://download.redis.io/releases/redis-3.2.6.tar.gz && \
tar xzf redis-3.2.6.tar.gz && \
cd redis-3.2.6 && \
make MALLOC=libc

RUN for file in $(grep -r --exclude=*.h --exclude=*.o /usr/local/src/redis-3.2.6/src | awk {'print $3'}); do cp $file /usr/local/bin; done && \
cp /usr/local/src/redis-3.2.6/src/redis-trib.rb /usr/local/bin && \
cp -r /usr/local/src/redis-3.2.6/utils /usr/local/bin && \
rm -rf /usr/local/src/redis*

COPY src/redis.conf /usr/local/etc/redis.conf
COPY src/*.sh /usr/local/bin/
COPY src/redis-trib.rb /usr/local/bin/


RUN mkdir /data && chown redis:redis /data && \
chown -R redis:redis /usr/local/bin/ && \
chown -R redis:redis /usr/local/etc/ && \
chmod +x /usr/local/bin/cluster-init.sh /usr/local/bin/redis-trib.rb

VOLUME /data
WORKDIR /data

USER redis

EXPOSE 6379 16379

CMD [ "redis-server", "/usr/local/etc/redis.conf" ]
