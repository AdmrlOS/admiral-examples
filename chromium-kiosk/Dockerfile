FROM ubuntu:noble

ENV DEBIAN_FRONTEND=noninteractive
ENV KIOSK_URL="https://google.com"
ENV XDG_RUNTIME_DIR=/tmp/xdg
ENV DISPLAY=:0

ARG AUTHORIZED_KEYS_URL=""

# 1. PPA setup
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        software-properties-common \
        gpg \
        wget \
        curl && \
    add-apt-repository -y ppa:xtradeb/apps

# 2. Pin the PPA so apt always prefers its Chromium
RUN printf "Package: chromium*\nPin: release o=LP-PPA-xtradeb-apps\nPin-Priority: 1001\n\nPackage: chromium-browser*\nPin: release o=LP-PPA-xtradeb-apps\nPin-Priority: 1001\n" \
    > /etc/apt/preferences.d/chromium-pin

# 3. Install runtime
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        openssh-server \
        ca-certificates \
        udev \
        sudo \
        mesa-utils \
        # Wayland / GL stack
        libgl1-mesa-dri \
        libgles2 \
        libegl1 \
        libgbm1 \
        vainfo \
        cage \
        grim \
        # Media drivers (Intel only on amd64)
        $( [ "$(dpkg --print-architecture)" = "amd64" ] && echo "intel-media-va-driver-non-free i965-va-driver" ) \
        mesa-va-drivers \
        mesa-vulkan-drivers \
        # Browser
        chromium \
        chromium-codecs-ffmpeg-extra && \
    rm -rf /var/lib/apt/lists/*

RUN usermod -a -G video,render,input root

# SSH
RUN mkdir -p /root/.ssh /run/sshd && chmod 700 /root/.ssh && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

RUN if [ -n "$AUTHORIZED_KEYS_URL" ]; then \
        curl -fsSL "$AUTHORIZED_KEYS_URL" -o /root/.ssh/authorized_keys && \
        chmod 600 /root/.ssh/authorized_keys; \
    fi

EXPOSE 22

COPY start.sh      /usr/local/bin/start.sh
COPY run-chrome.sh /usr/local/bin/run-chrome.sh
RUN chmod +x /usr/local/bin/start.sh /usr/local/bin/run-chrome.sh

CMD ["/usr/local/bin/start.sh"]
