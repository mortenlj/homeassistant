FROM hypriot/rpi-alpine:3.5

RUN apk update && \
    apk upgrade && \
    apk add bash && \
    apk add python3 && \
    rm -rf /var/cache/apk/*

RUN pip3 install homeassistant

EXPOSE 8123
CMD ["/usr/bin/hass", "--demo-mode", "--debug"]
