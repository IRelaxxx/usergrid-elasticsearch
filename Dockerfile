FROM debian:buster-slim

ENV DEBIAN_FRONTEND noninteractive

RUN mkdir /usr/share/man/man1/

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends software-properties-common curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
    
RUN echo 'Europe/Berlin' > /etc/timezone && \
    dpkg-reconfigure tzdata
    
RUN apt-add-repository 'deb http://security.debian.org/debian-security stretch/updates main' && \
    apt-get update && \
    apt-get install -y --no-install-recommends openjdk-8-jre-headless && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
    
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/

ENV ES_PKG_NAME elasticsearch-1.7.6

# install elasticsearch
RUN \
  cd / && \
  curl https://download.elasticsearch.org/elasticsearch/elasticsearch/$ES_PKG_NAME.tar.gz --output $ES_PKG_NAME.tar.gz && \
  tar xvzf $ES_PKG_NAME.tar.gz && \
  rm -f $ES_PKG_NAME.tar.gz && \
  mv /$ES_PKG_NAME /elasticsearch

# define mountable directories
VOLUME ["/data"]

# default command
CMD ["/elasticsearch/bin/elasticsearch"]

# expose ports
#   - 9200: HTTP
#   - 9300: native transport
EXPOSE 9200
EXPOSE 9300

# config
ADD elasticsearch.yml /elasticsearch/config/elasticsearch.yml 
