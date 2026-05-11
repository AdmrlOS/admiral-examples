#!/bin/bash
set -e

# 1. Hardware init
/usr/lib/systemd/systemd-udevd --daemon
udevadm trigger
udevadm settle

# 2. System DBus
if [ ! -S /run/dbus/system_bus_socket ]; then
    mkdir -p /run/dbus
    rm -f /run/dbus/pid
    dbus-daemon --system --fork
fi

# 3. Environment
export XDG_RUNTIME_DIR=/tmp/xdg
export WLR_BACKENDS=drm
export LIBSEAT_BACKEND=builtin
export WLR_LIBINPUT_NO_DEVICES=1

mkdir -p "$XDG_RUNTIME_DIR"
chmod 0700 "$XDG_RUNTIME_DIR"

: "${KIOSK_URL:=https://google.com}"

# 4. Launch
exec dbus-run-session -- cage -- chromium \
    --no-sandbox \
    --ozone-platform=wayland \
    --no-first-run \
    --kiosk \
    --force-dark-mode \
    --default-background-color=000000 \
    --enable-features=WebUIDarkMode,VaapiVideoDecoder,VaapiVideoEncoder,CanvasOopRasterization \
    --enable-gpu-rasterization \
    --enable-zero-copy \
    --ignore-gpu-blocklist \
    --disable-gpu-driver-bug-workarounds \
    "${KIOSK_URL}"
