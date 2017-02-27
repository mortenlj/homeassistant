#!/bin/sh

ha_req() {
    reqs=$(python3 -c "from ${1} import REQUIREMENTS; print(' '.join(REQUIREMENTS))")
    pip3 install ${reqs}
}

apk update
apk upgrade

apk add python3 ca-certificates yaml

apk add --virtual .build-deps build-base linux-headers python3-dev

pip3 install homeassistant

ha_req "homeassistant.components.media_player.cast"
ha_req "homeassistant.components.discovery"
ha_req "homeassistant.components.sensor.systemmonitor"

apk del .build-deps

rm -rf /var/cache/apk/*