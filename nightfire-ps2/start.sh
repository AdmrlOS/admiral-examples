#!/bin/sh
set -e

/usr/local/bin/run-pcsx2.sh &

mkdir -p /run/sshd
chmod 0755 /run/sshd

exec /usr/sbin/sshd -D
