# Docker Transmission

This is a Dockerfile to set up "Transmission" - (https://www.transmissionbt.com/)

## Build from docker file

```
git clone git@github.com:dhensen/docker-transmission.git
cd docker-transmission
docker build -t transmission .
```

## Run transmission

```
cd docker-transmission
export TRANSMISSION_EXTERNAL_PORT=45555
export TRANSMISSION_WEB_PORT=9091
docker run -d -v $(pwd)/watch:/watch \
    -v $(pwd)/complete:/downloads \
    -v $(pwd)/incomplete:/incomplete -v /*your_config_location*:/config -p $TRANSMISSION_EXTERNAL_PORT:45555 -p $TRANSMISSION_WEB_PORT:9091 -e "USERNAME=username" -e "PASSWORD=password"

```
