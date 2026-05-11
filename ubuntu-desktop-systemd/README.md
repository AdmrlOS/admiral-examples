# Ubuntu Desktop under systemd

A demonstration that you really can run full systemd — and a complete Ubuntu desktop environment — inside an Admiral container. Useful as a fallback compatibility shim for legacy software that assumes a standard Linux desktop.

⚠️ **This is not a recommended pattern.** Prefer the lighter examples (Chromium-kiosk, Doohly, Nightfire) for production. systemd-in-a-container brings significant overhead and complexity. Use this only when an application genuinely needs a full DE.

## What's Inside

- **Base:** `ubuntu:25.04`
- **Init:** systemd (PID 1)
- **DE:** `ubuntu-desktop-minimal`
- **User:** `qd` / `qdpassword` (sudoer)

## Build

```bash
docker build -t admiral/ubuntu-desktop:latest .
```

## Run

systemd needs a few things from the host to work cleanly:

```bash
docker run --rm -it \
  --tmpfs /run --tmpfs /run/lock \
  -v /sys/fs/cgroup:/sys/fs/cgroup:rw \
  --cgroupns=host \
  --device /dev/dri \
  -p 2222:22 \
  admiral/ubuntu-desktop:latest
```

## Login

- SSH: `ssh -p 2222 qd@<host>` (password: `qdpassword`, or use the keys configured at build time)
- Console: connect a display and the configured DM should come up.

## Changing the Default Password

Override at build time:

```bash
docker build --build-arg DEFAULT_PASSWORD=your-secret-here -t admiral/ubuntu-desktop:latest .
```

You should change this for any non-test deployment.
