#!/bin/bash
set -e

# Clean up state from any previous run
rm -f /tmp/.X0-lock
rm -rf /tmp/xdg

mkdir -p /run/sshd /run/dbus
mkdir -p -m 0700 /tmp/xdg

/usr/sbin/sshd
dbus-daemon --system --fork

# Start X + Openbox session
xinit -- /usr/bin/X :0 -nocursor -s 0 -dpms

# Keep PID 1 alive if xinit exits
exec tail -f /dev/null
