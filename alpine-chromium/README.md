# Alpine Chromium Kiosk (Framebuffer)

A bare-bones Chromium kiosk built on Alpine Linux. Uses the X11 framebuffer driver (`fbdev`) instead of DRM — useful on devices without working DRM/KMS, or for older ARM SBCs.

This is the smallest of the kiosk examples (~250MB compressed) and a good starting point for resource-constrained hardware.

## What's Inside

- **Base:** `alpine:3.21`
- **Display:** X11 with `xf86-video-fbdev`
- **WM:** Openbox
- **Browser:** Chromium

## Build

```bash
docker build -t admiral/alpine-chromium:latest .
```

## Run

```bash
docker run --rm -it \
  --device /dev/fb0 \
  --device /dev/input \
  --device /dev/tty0 \
  -p 2222:22 \
  admiral/alpine-chromium:latest
```

## Customising

The default URL is `https://google.com`. To change it, edit the `chromium --kiosk` line in `start.sh`, or modify the script to read from an env var.
