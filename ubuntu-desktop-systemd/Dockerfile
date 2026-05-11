FROM ubuntu:25.04

ARG DEFAULT_USER=qd
ARG DEFAULT_PASSWORD=qdpassword
ARG AUTHORIZED_KEYS_URL=""

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        systemd \
        systemd-sysv \
        kmod \
        ethtool \
        ubuntu-desktop-minimal \
        iproute2 \
        openssh-server \
        sudo \
        curl \
        ca-certificates && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Create the default user
RUN useradd -m -s /bin/bash "${DEFAULT_USER}" && \
    echo "${DEFAULT_USER}:${DEFAULT_PASSWORD}" | chpasswd && \
    usermod -aG sudo "${DEFAULT_USER}"

# SSH setup
RUN mkdir -p /var/run/sshd "/home/${DEFAULT_USER}/.ssh" && \
    chown "${DEFAULT_USER}:${DEFAULT_USER}" "/home/${DEFAULT_USER}/.ssh" && \
    chmod 700 "/home/${DEFAULT_USER}/.ssh"

RUN if [ -n "$AUTHORIZED_KEYS_URL" ]; then \
        curl -fsSL "$AUTHORIZED_KEYS_URL" -o "/home/${DEFAULT_USER}/.ssh/authorized_keys" && \
        chown "${DEFAULT_USER}:${DEFAULT_USER}" "/home/${DEFAULT_USER}/.ssh/authorized_keys" && \
        chmod 600 "/home/${DEFAULT_USER}/.ssh/authorized_keys"; \
    fi

# Disable Xfce screensaver / DPMS for the default user
RUN mkdir -p "/home/${DEFAULT_USER}/.config/xfce4/xfconf/xfce-perchannel-xml" && \
    printf '%s\n' \
        '<?xml version="1.0" encoding="UTF-8"?>' \
        '<channel name="xfce4-power-manager" version="1.0">' \
        '  <property name="locking" type="bool" value="false"/>' \
        '  <property name="dpms-on-ac-sleep" type="int" value="0"/>' \
        '  <property name="dpms-on-ac-off" type="int" value="0"/>' \
        '</channel>' \
        > "/home/${DEFAULT_USER}/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-power-manager.xml" && \
    chown -R "${DEFAULT_USER}:${DEFAULT_USER}" "/home/${DEFAULT_USER}/.config"

EXPOSE 22

STOPSIGNAL SIGRTMIN+3
CMD ["/lib/systemd/systemd"]
