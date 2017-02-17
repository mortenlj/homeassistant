#!/bin/bash

readonly PROGDIR=$(dirname $0)
pushd "${PROGDIR}" >/dev/null
readonly ROOTDIR=$(pwd)
popd >/dev/null
readonly TO="/tmp/babushka-my-machines"
readonly CONTAINER_NAME="babushka-test"

if [[ -n $(docker ps --filter "name=${CONTAINER_NAME}" -q) ]]; then
    echo Container is running
    docker exec -ti "${CONTAINER_NAME}" /bin/bash
elif [[ -n $(docker ps -a --filter "name=${CONTAINER_NAME}" -q) ]]; then
    echo Container exists, but is not running
    docker start "${CONTAINER_NAME}"
    docker exec -ti "${CONTAINER_NAME}" /bin/bash
else
    echo Container does not exist
    docker run --name  "${CONTAINER_NAME}" -ti -v "${ROOTDIR}":"${TO}" ubuntu:xenial /bin/bash 
fi
