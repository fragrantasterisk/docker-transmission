#!/bin/bash

# Add local user
# Either use the LOCAL_USER_ID if passed in at runtime or
# fallback

USER_ID=${LOCAL_USER_ID:-1000}

echo "Starting with UID : $USER_ID"
useradd -M -r -s /usr/sbin/nologin -u $USER_ID transmission

mkdir -p /config

if [ ! -f /config/settings.json ]; then
    mv /etc/transmission-daemon/settings.json /config/settings.json
    rm /var/lib/transmission-daemon/info/settings.json
else
    rm /var/lib/transmission-daemon/info/settings.json
    rm /etc/transmission-daemon/settings.json
fi

ln -sf /config/settings.json /var/lib/transmission-daemon/info/settings.json
ln -sf /config/settings.json /etc/transmission-daemon/settings.json

exec transmission /usr/bin/transmission-daemon --foreground --config-dir /config --log-info --username ${USERNAME} --peerport 45555 --password ${PASSWORD} --auth --watch-dir /watch --download-dir /downloads --incomplete-dir /incomplete
