FROM alpine:3.21

ARG AUTHORIZED_KEYS_URL=""

RUN apk update && apk add --no-cache \
        chromium \
        xorg-server \
        xf86-video-fbdev \
        xf86-input-libinput \
        xf86-input-evdev \
        xauth \
        xinit \
        openbox \
        openssh \
        dbus \
        eudev \
        acl \
        sudo \
        libinput-tools \
        evtest \
        font-noto \
        pulseaudio \
        bash \
        curl \
        tzdata

RUN addgroup root input && \
    addgroup root video && \
    addgroup root tty

# udev rule for input devices
RUN mkdir -p /etc/udev/rules.d && \
    echo 'SUBSYSTEM=="input", MODE="0666"' > /etc/udev/rules.d/99-input.rules

# X11 framebuffer + input config
RUN mkdir -p /etc/X11/xorg.conf.d && \
    printf '%s\n' \
        'Section "Device"' \
        '    Identifier "Framebuffer"' \
        '    Driver "fbdev"' \
        '    Option "fbdev" "/dev/fb0"' \
        'EndSection' \
        > /etc/X11/xorg.conf.d/99-fbdev.conf && \
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

# SSH
RUN mkdir -p /root/.ssh /run/sshd && chmod 700 /root/.ssh && \
    sed -i 's/#PermitRootLogin .*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    ssh-keygen -A

RUN if [ -n "$AUTHORIZED_KEYS_URL" ]; then \
        curl -fsSL "$AUTHORIZED_KEYS_URL" -o /root/.ssh/authorized_keys && \
        chmod 600 /root/.ssh/authorized_keys; \
    fi

COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 22

CMD ["/start.sh"]
