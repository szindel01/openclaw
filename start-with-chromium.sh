#!/bin/sh
# Start Chromium as a persistent CDP server before openclaw gateway

# If the container started as root, fix permissions on the persistent state
# (in case a host-side editor wrote files with the wrong UID), then drop to
# the unprivileged 'node' user (UID 1000) and re-exec this same script.
if [ "$(id -u)" = "0" ]; then
  chown -R 1000:1000 /home/node/.openclaw 2>/dev/null || true
  exec runuser -p -u node -- "$0" "$@"
fi

# Chromium désactivé — plugin browser désactivé dans openclaw.json
echo "[start-with-chromium] Chromium disabled (browser plugin off)"

# Start openclaw gateway
exec "$@"
