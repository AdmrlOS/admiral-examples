FROM ubuntu:noble

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:0

# Build arg: where to fetch authorized SSH keys from.
# Override with --build-arg AUTHORIZED_KEYS_URL=https://github.com/<you>.keys
ARG AUTHORIZED_KEYS_URL=""

# 1. Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        software-properties-common \
        gpg \
        wget \
        curl && \
    add-apt-repository -y ppa:pcsx2-team/pcsx2-daily && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        # System
        openssh-server \
        ca-certificates \
        udev \
        dbus \
        sudo \
        # X11
        x11-xserver-utils \
        xserver-xorg-core \
        xserver-xorg-video-all \
        xserver-xorg-input-evdev \
        xserver-xorg-input-libinput \
        xinit \
        openbox \
        input-utils \
        # Graphics
        libgl1-mesa-dri \
        libglx-mesa0 \
        mesa-vulkan-drivers \
        mesa-va-drivers \
        # Audio (ALSA only)
        alsa-utils \
        alsa-ucm-conf \
        alsa-topology-conf \
        libasound2t64 \
        # Emulator
        pcsx2-unstable && \
    rm -rf /var/lib/apt/lists/*

# 2. Permissions
RUN usermod -a -G video,render,input,audio,tty root

# 3. Remove PulseAudio plugins that hijack ALSA
RUN apt-get remove -y libasound2-plugins || true

# 4. Input configuration
RUN mkdir -p /etc/X11/xorg.conf.d && \
    printf '%s\n' \
        'Section "InputClass"' \
        '    Identifier "evdev keyboard catchall"' \
        '    MatchIsKeyboard "on"' \
        '    MatchDevicePath "/dev/input/event*"' \
        '    Driver "evdev"' \
        '    Option "GrabDevice" "true"' \
        'EndSection' \
        '' \
        'Section "InputClass"' \
        '    Identifier "evdev pointer catchall"' \
        '    MatchIsPointer "on"' \
        '    MatchDevicePath "/dev/input/event*"' \
        '    Driver "evdev"' \
        '    Option "GrabDevice" "true"' \
        'EndSection' \
        > /etc/X11/xorg.conf.d/10-input.conf

# 5. Directories
RUN mkdir -p /root/.config/PCSX2/bios /root/.config/PCSX2/inis /root/games

# 6. Assets — supply your own BIOS and ISO before building
COPY ./bios/ /root/.config/PCSX2/bios/
COPY ./nightfire.iso /root/games/007_Nightfire.iso
COPY ./PCSX2.ini /root/.config/PCSX2/inis/PCSX2.ini

# 7. SSH
RUN mkdir -p /root/.ssh /run/sshd && chmod 700 /root/.ssh && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

RUN if [ -n "$AUTHORIZED_KEYS_URL" ]; then \
        curl -fsSL "$AUTHORIZED_KEYS_URL" -o /root/.ssh/authorized_keys && \
        chmod 600 /root/.ssh/authorized_keys; \
    fi

EXPOSE 22

# 8. Scripts
COPY start.sh /usr/local/bin/start.sh
COPY run-pcsx2.sh /usr/local/bin/run-pcsx2.sh
RUN chmod +x /usr/local/bin/start.sh /usr/local/bin/run-pcsx2.sh

CMD ["/usr/local/bin/start.sh"]
