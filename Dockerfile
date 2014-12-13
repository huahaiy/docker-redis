#
# The latest Redis on the latest Debian Stable
# 
#
# Version     0.1
#

FROM huahaiy/debian

RUN \
  echo "===> get dependencies" && \
  apt-get update && \
  apt-get -y install make gcc && \
  \
  \
  echo "===> get and build Redis" && \
  cd /tmp && \
  wget http://download.redis.io/redis-stable.tar.gz && \
  tar xvzf redis-stable.tar.gz && \
  cd redis-stable && \
  make && \
  make install && \
  cp -f src/redis-sentinel /usr/local/bin && \
  mkdir -p /etc/redis && \
  cp -f *.conf /etc/redis && \
  sed -i 's/^\(bind .*\)$/# \1/' /etc/redis/redis.conf && \
  sed -i 's/^\(daemonize .*\)$/# \1/' /etc/redis/redis.conf && \
  sed -i 's/^\(dir .*\)$/# \1\ndir \/data/' /etc/redis/redis.conf && \
  sed -i 's/^\(logfile .*\)$/# \1/' /etc/redis/redis.conf && \
  \
  \
  echo "===> clean up" && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

VOLUME ["/data"]

WORKDIR /data

EXPOSE 6379

CMD ["redis-server", "/etc/redis/redis.conf"]
