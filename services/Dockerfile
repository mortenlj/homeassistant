FROM hypriot/rpi-alpine:3.5

COPY install.sh /
RUN /install.sh

RUN mkdir -p /home-assistant
COPY configuration.yaml /home-assistant/
COPY known_devices.yaml /home-assistant/
COPY secrets.yaml /home-assistant/

EXPOSE 8123
CMD ["/usr/bin/hass", "--config", "/home-assistant"]
