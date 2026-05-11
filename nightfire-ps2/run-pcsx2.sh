#!/bin/bash
set -e

# 1. Hardware init
/usr/lib/systemd/systemd-udevd --daemon
udevadm trigger
udevadm settle
sleep 1

# Input permissions
for dev in /dev/input/event*; do
    [ -e "$dev" ] && chmod 666 "$dev"
done

# 2. Audio setup
chmod 666 /dev/snd/* 2>/dev/null || true
alsactl init >/dev/null 2>&1 || true

# Unmute every card we can find
awk '/ \[/ {print $1}' /proc/asound/cards | while read -r card; do
    for ctrl in Master PCM Speaker Headphone; do
        amixer -c "$card" sset "$ctrl" unmute 100% >/dev/null 2>&1 || true
    done
done

# 3. Detect a non-HDMI analog output
aplay -l > /tmp/sound_cards.txt 2>/dev/null || true

CARD_LINE=$(grep -iE "analog|speaker|headphone|conexant|realtek|generic" /tmp/sound_cards.txt 2>/dev/null \
            | grep -vi "hdmi" | head -n 1)

if [ -z "$CARD_LINE" ]; then
    CARD_LINE=$(grep "^card" /tmp/sound_cards.txt 2>/dev/null | grep -vi "hdmi" | head -n 1)
fi

if [ -z "$CARD_LINE" ]; then
    TARGET_CARD=0
    TARGET_DEVICE=0
else
    TARGET_CARD=$(echo "$CARD_LINE" | sed -n 's/^card \([0-9]\+\):.*/\1/p')
    TARGET_DEVICE=$(echo "$CARD_LINE" | sed -n 's/.*device \([0-9]\+\):.*/\1/p')
fi

# 4. Write ALSA config
cat > /etc/asound.conf <<EOF
pcm.!default {
    type plug
    slave {
        pcm "hw:${TARGET_CARD},${TARGET_DEVICE}"
        rate 48000
    }
}
ctl.!default {
    type hw
    card ${TARGET_CARD}
}
EOF

# 5. Environment
export DISPLAY=:0
export QT_QPA_PLATFORM=xcb
export CUBEB_BACKEND=alsa
export SDL_VIDEODRIVER=x11

# 6. Window manager + xinit
mkdir -p /root/.config/openbox
cat > /root/.config/openbox/rc.xml <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<openbox_config xmlns="http://openbox.org/3.4/rc">
  <applications>
    <application class="*">
      <decorations>no</decorations>
      <maximized>yes</maximized>
      <fullscreen>yes</fullscreen>
    </application>
  </applications>
</openbox_config>
EOF

cat > /root/.xinitrc <<'EOF'
#!/bin/sh
xset s off
xset -dpms
xset s noblank

# Force 1080p if possible
OUTPUT=$(xrandr | awk '/ connected/ {print $1; exit}')
if [ -n "$OUTPUT" ]; then
    xrandr --output "$OUTPUT" --mode 1920x1080 2>/dev/null || true
fi

openbox &
sleep 2

exec pcsx2-qt -batch -fullscreen -- "/root/games/007_Nightfire.iso"
EOF
chmod +x /root/.xinitrc

# 7. Launch
exec xinit /root/.xinitrc -- /usr/bin/X :0 -ac -nocursor -s 0 -dpms -allowMouseOpenFail
