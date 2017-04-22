#!/bin/sh

ha_req() {
    reqs=$(python3 -c "from ${1} import REQUIREMENTS; print(' '.join(REQUIREMENTS))")
    pip3 install ${reqs}
}

apk update
apk upgrade

apk add python3 ca-certificates yaml

apk add --virtual .build-deps build-base linux-headers python3-dev

pip3 install "homeassistant==${HOME_ASSISTANT_VERSION}"

ha_req "homeassistant.components.sensor.systemmonitor"
ha_req "homeassistant.components.rpi_gpio"
ha_req "homeassistant.components.http"
ha_req "homeassistant.components.sensor.yahoo_finance"
ha_req "homeassistant.components.sensor.yr"
ha_req "homeassistant.components.discovery"
ha_req "homeassistant.components.updater"

apk del .build-deps

rm -rf /var/cache/apk/*
