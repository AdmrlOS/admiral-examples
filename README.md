<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://admrl.co/logo/admiral-logo.svg">
    <source media="(prefers-color-scheme: light)" srcset="https://admrl.co/logo/admiral-logo-dark.svg">
    <img alt="Admiral" src="https://admrl.co/logo/admiral-logo.svg" width="280">
  </picture>
</p>

<h1 align="center">Admiral Examples</h1>

<p align="center">
  Reference container images for the <a href="https://admrl.co">Admiral</a> edge platform.
</p>

<p align="center">
  <a href="./LICENSE">
    <img alt="License" src="https://img.shields.io/badge/license-MIT-blue.svg">
  </a>
</p>

---

# Admiral Examples

A collection of reference container images for the [Admiral](https://admrl.co) edge platform.

Admiral runs OCI containers directly on edge hardware — phones, kiosks, signage, set-top boxes, anything with a Linux kernel and a screen. These examples show how to build images that take advantage of the host's GPU, audio, input devices, and network.

## Examples

| Example | Description | Base Image |
|---|---|---|
| [nightfire-ps2](./nightfire-ps2) | PCSX2 emulating *007: Nightfire* with hardware audio/input passthrough | `ubuntu:noble` |
| [doohly-signage](./doohly-signage) | Doohly digital signage player in Openbox kiosk mode | `debian:trixie` |
| [chromium-kiosk](./chromium-kiosk) | Wayland-based Chromium kiosk with hardware video acceleration | `ubuntu:noble` |
| [alpine-chromium](./alpine-chromium) | Minimal Chromium kiosk on Alpine using framebuffer + X11 | `alpine:3.21` |
| [ubuntu-desktop-systemd](./ubuntu-desktop-systemd) | Full Ubuntu desktop running under systemd inside a container | `ubuntu:25.04` |

## Common Patterns

Every example in this repo follows a few conventions:

### 1. SSH Access

Each image runs `sshd` so you can debug live on a deployed device. To inject your own SSH keys at build time, edit the `AUTHORIZED_KEYS_URL` build arg or replace the `ADD https://github.com/<you>.keys` line in the Dockerfile.

```dockerfile
ARG AUTHORIZED_KEYS_URL=https://github.com/your-username.keys
ADD ${AUTHORIZED_KEYS_URL} /root/.ssh/authorized_keys
```

Build with:

```bash
docker build --build-arg AUTHORIZED_KEYS_URL=https://github.com/your-username.keys -t my-image .
```

### 2. Hardware Access

Admiral provides containers with access to the host's `/dev/dri`, `/dev/input`, `/dev/snd`, and `/dev/fb*` devices. Your container is responsible for setting permissions and detecting devices at runtime — see `run-*.sh` scripts in each example.

### 3. Init

These images don't assume systemd. Most of them use a small `start.sh` PID 1 that launches a background graphical app and then `exec`s `sshd` in the foreground. The `ubuntu-desktop-systemd` example is the exception — it shows how to run full systemd if you really need it.

## Building & Pushing

```bash
cd nightfire-ps2
docker build -t registry.example.com/admiral/nightfire:latest .
docker push registry.example.com/admiral/nightfire:latest
```

Then deploy via the Admiral dashboard or API.

## Contributing

PRs welcome. New examples should:

- Include a self-contained `README.md`
- Avoid hard-coded personal credentials, keys, or private URLs
- Document any hardware requirements (GPU vendor, audio backend, etc.)
- Use a pinned base image tag (no `:latest`)

## License

MIT — see [LICENSE](./LICENSE).
