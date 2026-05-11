# Chromium Kiosk (Wayland)

A minimal Wayland-based Chromium kiosk with hardware video acceleration. Uses [`cage`](https://github.com/cage-kiosk/cage) — a Wayland compositor that runs exactly one fullscreen application — instead of a full DE.

Particularly well-suited to Rockchip SoCs (RK3588 etc.) where the [xtradeb PPA](https://launchpad.net/~xtradeb/+archive/ubuntu/apps) ships a Chromium build with VA-API + RKMPP enabled.

## What's Inside

- **Base:** `ubuntu:noble`
- **Compositor:** `cage` (single-app Wayland)
- **Browser:** Chromium from `ppa:xtradeb/apps`, pinned to that PPA
- **Acceleration:** VA-API via `mesa-va-drivers` and Intel's `i965`/`intel-media-va-driver-non-free` on x86_64

## Build

```bash
docker build -t admiral/chromium-kiosk:latest .
```

## Run

```bash
docker run --rm -it \
  -e KIOSK_URL="https://example.com" \
  --device /dev/dri \
  --device /dev/input \
  -p 2222:22 \
  admiral/chromium-kiosk:latest
```

## Configuration

| Env Var | Default | Description |
|---|---|---|
| `KIOSK_URL` | `https://google.com` | URL to load on startup |

## Notes

- The Chromium flag set in `run-chrome.sh` enables GPU rasterization, zero-copy texture upload, and the VA-API decoder. Remove `--ignore-gpu-blocklist` and `--disable-gpu-driver-bug-workarounds` if you'd rather Chromium decide for itself.
- `cage` requires DRM access — without `--device /dev/dri` it will fail to start.
