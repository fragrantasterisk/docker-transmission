# FROM timhaak/base
FROM ubuntu:17.04

LABEL maintainer "Dino Hensen <dino.hensen@gmail.com>"

ENV GOSU_VERSION 1.10
RUN set -ex; \
    \
    fetchDeps=' \
        ca-certificates \
        wget \
        dirmngr \
    '; \
    apt-get update; \
    apt-get install -y --no-install-recommends $fetchDeps; \
    rm -rf /var/lib/apt/lists/*; \
    \
    dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"; \
    wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch"; \
    wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc"; \
    \
# verify the signature
    export GNUPGHOME="$(mktemp -d)"; \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4; \
    gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu; \
    rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc; \
    \
    chmod +x /usr/local/bin/gosu; \
# verify that the binary works
    gosu nobody true; \
    \
    apt-get purge -y --auto-remove $fetchDeps

RUN apt-get update && \
    apt-get -y install software-properties-common && \
    add-apt-repository -y ppa:transmissionbt/ppa && \
    apt-get -y install transmission-daemon ca-certificates wget tar curl unrar-free procps && \
    apt-get -y autoremove && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

VOLUME ["/downloads", "/incomplete", "/watch", "/config"]


ADD ./start.sh /start.sh
RUN chmod u+x  /start.sh
COPY settings.json /var/lib/transmission-daemon/info/settings.json

EXPOSE 9091 45555

ENV USERNAME="transmission" \
    PASSWORD="password"

CMD ["/start.sh"]
