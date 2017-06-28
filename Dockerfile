# FROM timhaak/base
FROM ubuntu:17.04

LABEL maintainer "Dino Hensen <dino.hensen@gmail.com>"

ADD su-exec /usr/local/bin/su-exec
RUN chmod +x /usr/local/bin/su-exec

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
