FROM hypriot/rpi-alpine:3.5

COPY install.sh /
ARG HOME_ASSISTANT_VERSION=0.51.2
RUN /install.sh

RUN mkdir -p /home-assistant

EXPOSE 8123
CMD ["/usr/bin/hass", "--config", "/home-assistant"]
