#!/bin/sh

set -euo pipefail

ha_req() {
    reqs=$(python3 -c "from ${1} import REQUIREMENTS; print(' '.join(REQUIREMENTS))")
    pip3 install ${reqs}
}

apk update
apk upgrade

apk add python3 ca-certificates yaml libffi openssl

apk add --virtual .build-deps build-base linux-headers python3-dev libffi-dev openssl-dev

pip3 install "homeassistant==${HOME_ASSISTANT_VERSION}"

ha_req "homeassistant.components.sensor.systemmonitor"
ha_req "homeassistant.components.mqtt"
ha_req "homeassistant.components.mqtt.server"
ha_req "homeassistant.components.http"
ha_req "homeassistant.components.sensor.yahoo_finance"
ha_req "homeassistant.components.sensor.yr"
ha_req "homeassistant.components.discovery"
ha_req "homeassistant.components.updater"
ha_req "homeassistant.components.prometheus"

ha_req "homeassistant.auth.mfa_modules.totp"

apk del .build-deps

rm -rf /var/cache/apk/*
