FROM debian:trixie

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:0
ENV HOME=/root
ENV XDG_RUNTIME_DIR=/tmp/xdg

ARG TARGETARCH
ARG APPIMAGE_VERSION=5.9.9
ARG AUTHORIZED_KEYS_URL=""
ENV APPIMAGE_PATH=/opt/doohly-player.AppImage

RUN apt-get update && apt-get install -y --no-install-recommends \
        xserver-xorg-core \
        xinit \
        openbox \
        openssh-server \
        dbus-x11 \
        udev \
        sudo \
        fonts-noto \
        mesa-utils \
        libgl1-mesa-dri \
        $( [ "$(dpkg --print-architecture)" = "amd64" ] && echo "intel-media-va-driver i965-va-driver" ) \
        mesa-va-drivers \
        mesa-vulkan-drivers \
        vainfo \
        python3-xdg \
        unclutter \
        fuse \
        libfuse2t64 \
        libnss3 \
        libatk1.0-0 \
        libatk-bridge2.0-0 \
        libgtk-3-0 \
        libasound2t64 \
        alsa-utils \
        curl \
        ca-certificates && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Download the appropriate AppImage
RUN if [ "$TARGETARCH" = "arm64" ]; then \
        URL="https://doohly-production-static.s3.ap-southeast-2.amazonaws.com/installers/linux/${APPIMAGE_VERSION}/arm64/doohly-player-v${APPIMAGE_VERSION}-arm64.AppImage"; \
    else \
        URL="https://doohly-production-static.s3.ap-southeast-2.amazonaws.com/installers/linux/${APPIMAGE_VERSION}/x86_64/doohly-player-v${APPIMAGE_VERSION}-x86_64.AppImage"; \
    fi; \
    curl -fsSL -o "${APPIMAGE_PATH}" "${URL}" && chmod +x "${APPIMAGE_PATH}"

RUN usermod -a -G video,render,input,audio root

# SSH
RUN mkdir -p /root/.ssh /run/sshd && chmod 700 /root/.ssh && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

RUN if [ -n "$AUTHORIZED_KEYS_URL" ]; then \
        curl -fsSL "$AUTHORIZED_KEYS_URL" -o /root/.ssh/authorized_keys && \
        chmod 600 /root/.ssh/authorized_keys; \
    fi

# Openbox config (system-wide so /root/.config stays clean for the AppImage)
RUN mkdir -p /etc/xdg/openbox
COPY autostart /etc/xdg/openbox/autostart
COPY rc.xml    /etc/xdg/openbox/rc.xml
RUN chmod +x /etc/xdg/openbox/autostart

COPY xinitrc /root/.xinitrc
COPY start.sh /start.sh
RUN chmod +x /root/.xinitrc /start.sh

EXPOSE 22

CMD ["/start.sh"]
