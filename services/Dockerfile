FROM hypriot/rpi-alpine:3.6

RUN apk update && \
    apk upgrade && \
    apk --no-cache add python3 ca-certificates yaml libffi openssl

RUN apk --no-cache add --virtual .build-deps build-base linux-headers python3-dev libffi-dev openssl-dev jq

COPY install.sh /
COPY .wheel_cache/ /links/

ARG HOME_ASSISTANT_VERSION=0.97.2

RUN pip3 install wheel && \
    pip3 wheel --no-cache-dir --wheel-dir=/wheels/ --find-links=/links/ "homeassistant==${HOME_ASSISTANT_VERSION}"

RUN pip3 install --no-index --no-cache-dir --find-links=/wheels/ "homeassistant==${HOME_ASSISTANT_VERSION}"

RUN /install.sh wheel
RUN /install.sh install

RUN apk del .build-deps

RUN mkdir -p /home-assistant

EXPOSE 8123
CMD ["/usr/bin/hass", "--config", "/home-assistant"]
