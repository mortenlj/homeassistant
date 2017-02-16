#!/bin/bash

readonly PROGDIR=$(dirname $0)
pushd "${PROGDIR}" >/dev/null
readonly ROOTDIR=$(pwd)
popd >/dev/null
readonly TO="/tmp/babushka-my-machines"

docker run -ti -v "${ROOTDIR}":"${TO}" ubuntu:xenial /bin/bash -c "${TO}/init.sh"
