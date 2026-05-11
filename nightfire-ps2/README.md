# Nightfire PS2 — PCSX2 in a Container

Runs the PS2 emulator [PCSX2](https://pcsx2.net/) in fullscreen kiosk mode, booting directly into *007: Nightfire*. This is the image used in our [blog post](https://admrl.co/blog) demonstrating console emulation on Admiral.

## What's Inside

- **Base:** `ubuntu:noble`
- **Emulator:** `pcsx2-unstable` from the official PCSX2 daily PPA
- **Display:** X11 (`xinit` + `openbox`) at 1920×1080
- **Audio:** ALSA via Cubeb, with runtime card detection
- **Input:** evdev passthrough from `/dev/input/event*`

## Required Files (Not Included)

You must supply these yourself — they are **not** redistributed in this repo for legal reasons:

```
bios/SCPH-70012_BIOS_V12_USA_200.BIN
bios/SCPH-70012_BIOS_V12_USA_200.MEC
bios/SCPH-70012_BIOS_V12_USA_200.NVM
nightfire.iso
```

Drop your own PS2 BIOS files into `./bios/` and your own legally-dumped game ISO at `./nightfire.iso` before building. To use a different game, edit `Dockerfile` and `run-pcsx2.sh` accordingly.

## Build

```bash
docker build -t admiral/nightfire-ps2:latest .
```

## Run (Locally, for Testing)

```bash
docker run --rm -it \
  --device /dev/dri \
  --device /dev/snd \
  --device /dev/input \
  -p 2222:22 \
  admiral/nightfire-ps2:latest
```

## Hardware Notes

- Tested on x86_64 with Intel iGPU and on RK3588 with Mali GPU.
- The audio detection script in `run-pcsx2.sh` tries to find a non-HDMI analog output. If your device only has HDMI audio, edit the grep filter.
- If controllers don't work, ensure `/dev/input` is bind-mounted and that your device's evdev nodes have permissions `0666`.

## Customising

- **Different game:** replace `nightfire.iso` and update the `pcsx2-qt` invocation at the bottom of `run-pcsx2.sh`.
- **Different BIOS region:** swap the BIOS files and update `Filenames.BIOS` in `PCSX2.ini`.
- **Controller mappings:** see the `[Pad1]` section of `PCSX2.ini`.
