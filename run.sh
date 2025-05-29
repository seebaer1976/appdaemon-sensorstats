#!/usr/bin/with-contenv bashio

echo "[INFO] Starte SensorStats mit AppDaemon..."

mkdir -p /config/appdaemon/apps/sensorstats/
cp -r /config/sensorstats/* /config/appdaemon/apps/sensorstats/

cat <<EOF > /config/appdaemon/appdaemon.yaml
appdaemon:
  time_zone: Europe/Berlin
  plugins:
    HASS:
      type: hass
      ha_url: http://homeassistant.local:8123
      token: $(bashio::config 'token')

appdir: /config/appdaemon/apps
EOF

# Starte AppDaemon
exec appdaemon -c /config/appdaemon