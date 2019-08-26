#!/bin/sh

set -euo pipefail

operation="${1}"
case "${1}" in
  wheel)
    pip_args="--wheel-dir=/wheels/ --find-links=/links/"
    ;;
  install)
    pip_args="--find-links=/wheels/"
    ;;
esac

ha_req() {
  jq -r .requirements[] < $(python3 -c "import pkg_resources; print(pkg_resources.resource_filename(\"${1}\", \"manifest.json\"))") | \
    xargs -r pip3 "${operation}" --no-cache-dir ${pip_args}
}

ha_req "homeassistant.components.systemmonitor"
ha_req "homeassistant.components.mqtt"
ha_req "homeassistant.components.mqtt.server"
ha_req "homeassistant.components.http"
ha_req "homeassistant.components.yr"
ha_req "homeassistant.components.discovery"
ha_req "homeassistant.components.updater"
ha_req "homeassistant.components.prometheus"
