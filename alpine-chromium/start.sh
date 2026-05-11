#!/bin/bash
set -e

# Start SSH
mkdir -p /run/sshd
/usr/sbin/sshd

# Allow access to input devices
chmod 666 /dev/input/* 2>/dev/null || true

# .xinitrc launches WM + browser
cat > /root/.xinitrc <<'EOF'
#!/bin/sh
openbox &
chromium --no-sandbox --kiosk "https://google.com" &
exec tail -f /dev/null
EOF
chmod +x /root/.xinitrc

# Run X in the foreground — this becomes PID 1's main child
exec xinit /root/.xinitrc -- /usr/bin/X :0 -ac -nocursor -s 0 -dpms -allowMouseOpenFail
