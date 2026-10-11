#!/bin/sh
# Systemd suspend/resume hook to restore Grayscale on wake
case "$1" in
    post)
        sleep 1.5
        # Dynamically determine the active graphical user
        TARGET_USER=$(who | awk 'NR==1{print $1}')
        if [ -z "$TARGET_USER" ]; then
            TARGET_USER=$(id -un 1000 2>/dev/null || echo "dan-brown")
        fi
        TARGET_HOME=$(getent passwd "$TARGET_USER" | cut -d: -f6)

        if [ -x "$TARGET_HOME/.local/bin/toggle-bw" ]; then
            su - "$TARGET_USER" -c "$TARGET_HOME/.local/bin/toggle-bw --force-on" >/dev/null 2>&1 &
        elif [ -x "/usr/local/bin/toggle-bw" ]; then
            su - "$TARGET_USER" -c "/usr/local/bin/toggle-bw --force-on" >/dev/null 2>&1 &
        fi
        ;;
esac
