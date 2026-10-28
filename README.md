<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://admrl.co/logo/admiral-logo.svg">
    <source media="(prefers-color-scheme: light)" srcset="https://admrl.co/logo/admiral-logo-dark.svg">
    <img alt="Admiral" src="https://admrl.co/logo/admiral-logo.svg" width="280">
  </picture>
</p>

<h1 align="center">Admiral Examples</h1>

<p align="center">
  Simple build examples and workload starting points for the <a href="https://admrl.co">Admiral</a> edge platform.
</p>

<p align="center">
  <a href="./LICENSE">
    <img alt="License" src="https://img.shields.io/badge/license-MIT-blue.svg">
  </a>
</p>

---

# Admiral Examples

Examples and starting points for building workloads on the [Admiral](https://admrl.co) edge platform, from kiosks and signage to robotics and accelerated computing.

The examples included in this repository are simple, self-contained demonstrations of how to build and package OCI workload images. They show the basics of startup, device access, graphics, audio, and networking.

For more sophisticated applications, the separate public `workload-*` repositories below provide starting points for robotics with Copper or ROS 2, CUDA workloads, edge AI, and other complete applications.

## Included Examples

| Example | Description | Base Image |
|---|---|---|
| [nightfire-ps2](./nightfire-ps2) | PCSX2 emulating *007: Nightfire* with hardware audio/input passthrough | `ubuntu:noble` |
| [doohly-signage](./doohly-signage) | Doohly digital signage player in Openbox kiosk mode | `debian:trixie` |
| [chromium-kiosk](./chromium-kiosk) | Wayland-based Chromium kiosk with hardware video acceleration | `ubuntu:noble` |
| [alpine-chromium](./alpine-chromium) | Minimal Chromium kiosk on Alpine using framebuffer + X11 | `alpine:3.21` |
| [ubuntu-desktop-systemd](./ubuntu-desktop-systemd) | Full Ubuntu desktop running under systemd inside a container | `ubuntu:25.04` |

## Public Workload Starting Points

These standalone repositories go beyond the simple build examples above. They provide application stacks, runtime integration, and deployment patterns to adapt for your own workloads.

| Workload | Starting Point |
|---|---|
| [workload-admiral-signage](https://github.com/AdmrlOS/workload-admiral-signage) | Signage development workload with a content studio, WPE WebKit, GPU rendering, and video integration on Allwinner T527. |
| [workload-copper](https://github.com/AdmrlOS/workload-copper) | Copper robotics with a simulated warehouse rover, native control, telemetry, recordings, and verified replay. |
| [workload-copper-flight](https://github.com/AdmrlOS/workload-copper-flight) | Copper flight simulation with native physics, CPU/CUDA policy inference, and a browser mission monitor. |
| [workload-cuda-debug](https://github.com/AdmrlOS/workload-cuda-debug) | CUDA compute and driver diagnostics for NVIDIA Jetson, including runtime and PTX JIT checks. |
| [workload-embedded-browser](https://github.com/AdmrlOS/workload-embedded-browser) | Reusable ARM64 WPE WebKit base for embedded kiosks, dashboards, and signage on Allwinner T527. |
| [workload-jukebox](https://github.com/AdmrlOS/workload-jukebox) | AirPlay and Spotify Connect audio workload with configurable outputs and a local dashboard. |
| [workload-nixos-demo](https://github.com/AdmrlOS/workload-nixos-demo) | NixOS userspace with systemd, on-device LLM chat, and CUDA integration on NVIDIA Jetson. |
| [workload-npu-demo](https://github.com/AdmrlOS/workload-npu-demo) | llama.cpp text and image inference with mainline Rocket NPU offload on RK3588. |
| [workload-ros2](https://github.com/AdmrlOS/workload-ros2) | ROS 2 C++ talker and Python listener with CycloneDDS discovery, service supervision, and optional SSH diagnostics. |
| [workload-unitree-g1](https://github.com/AdmrlOS/workload-unitree-g1) | Reusable application userspace for the Unitree G1's Jetson Orin NX, including service management and camera integration. |

Follow each repository's README for its build instructions, target hardware, and Admiral deployment configuration.

## Common Patterns

The examples included in this repository follow a few conventions:

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

MIT — see [LICENSE](./LICENSE). The linked workload repositories have their own licensing.
