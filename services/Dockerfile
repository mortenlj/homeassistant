FROM hypriot/rpi-alpine:3.5

RUN apk update && \
    apk upgrade && \
    apk add bash && \
    apk add python3 && \
    apk add ca-certificates && \
    rm -rf /var/cache/apk/*

RUN pip3 install homeassistant

RUN mkdir -p /home-assistant
COPY configuration.yaml /home-assistant/
COPY known_devices.yaml /home-assistant/

EXPOSE 8123
CMD ["/usr/bin/hass", "--config", "/home-assistant"]
