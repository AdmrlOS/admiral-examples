# Doohly Signage Player

Runs the [Doohly](https://dooh.ly) digital signage AppImage in a fullscreen Openbox kiosk session. Multi-arch (`amd64` + `arm64`).

## What's Inside

- **Base:** `debian:trixie`
- **WM:** Openbox in kiosk mode
- **Player:** Doohly Player AppImage (downloaded at build time)
- **Display:** X11 via `xinit`

## Build

```bash
# Single-arch
docker build -t admiral/doohly-signage:latest .

# Multi-arch
docker buildx build --platform linux/amd64,linux/arm64 \
  -t admiral/doohly-signage:latest --push .
```

You can pin a specific Doohly Player version with `--build-arg`:

```bash
docker build --build-arg APPIMAGE_VERSION=5.9.9 -t admiral/doohly-signage:latest .
```

## Run

```bash
docker run --rm -it \
  --device /dev/dri \
  --device /dev/input \
  -p 2222:22 \
  admiral/doohly-signage:latest
```

The first time the player starts, it will display a pairing code. Pair the device through the Doohly dashboard.
