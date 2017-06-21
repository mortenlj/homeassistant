FROM hypriot/rpi-alpine:3.5

COPY install.sh /
ARG HOME_ASSISTANT_VERSION=0.43.0
RUN /install.sh

COPY linksys_smart.py /usr/lib/python3.5/site-packages/homeassistant/components/device_tracker/

RUN mkdir -p /home-assistant

EXPOSE 8123
CMD ["/usr/bin/hass", "--config", "/home-assistant"]
