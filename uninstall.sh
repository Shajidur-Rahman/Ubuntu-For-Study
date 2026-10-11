#!/usr/bin/env bash
# ==============================================================================
# Ubuntu-For-Study: Uninstaller & Default Restorer
# ==============================================================================
set -e

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root: sudo bash $0"
    exit 1
fi

if [ -n "$SUDO_USER" ] && [ "$SUDO_USER" != "root" ]; then
    TARGET_USER="$SUDO_USER"
else
    TARGET_USER=$(id -un 1000 2>/dev/null || who | awk 'NR==1{print $1}')
fi

TARGET_HOME=$(getent passwd "$TARGET_USER" | cut -d: -f6)

echo "Restoring system to default settings..."

# 1. Stop and disable self-healing guardian
systemctl disable --now study-guardian.service 2>/dev/null || true
rm -f /etc/systemd/system/study-guardian.service
systemctl daemon-reload

# 2. Restore /etc/hosts
chattr -i /etc/hosts 2>/dev/null || true
if [ -f /etc/study-mode-backup/hosts.bak ]; then
    cp /etc/study-mode-backup/hosts.bak /etc/hosts
else
    cat << 'EOF' > /etc/hosts
127.0.0.1 localhost.localdomain localhost
::1 localhost6.localdomain6 localhost6
::1 localhost ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
ff02::3 ip6-allhosts
EOF
fi

# 3. Restore DNS
rm -f /etc/systemd/resolved.conf.d/strict-study-dns.conf
systemctl restart systemd-resolved
resolvectl flush-caches 2>/dev/null || true

# 4. Remove browser policies
rm -f /etc/opt/chrome/policies/managed/study-restrictions.json
rm -f /etc/brave/policies/managed/study-restrictions.json
rm -f /etc/firefox/policies/policies.json
rm -f /var/snap/firefox/current/policies/policies.json 2>/dev/null || true

# 5. Remove daemon & sudoers
rm -f /etc/sudoers.d/study-timer
rm -f /usr/local/bin/study-timer-daemon /usr/local/bin/study-fb-daemon
rm -f /usr/local/bin/study-fb /usr/local/bin/study-reddit /usr/local/bin/toggle-bw /usr/local/bin/focus /usr/local/bin/study-browser
rm -f /usr/local/bin/hsc_math_engine.py /usr/local/bin/study_lockout.py /usr/local/bin/study-screen-listener
rm -rf /etc/study-timer /usr/share/study-browser "$TARGET_HOME/.config/study-browser"
rm -f /lib/systemd/system-sleep/study-resume-grayscale.sh
rm -f "$TARGET_HOME/.config/systemd/user/study-screen-listener.service"
su - "$TARGET_USER" -c "systemctl --user disable --now study-screen-listener.service" 2>/dev/null || true

# 6. Restore Color & Desktop settings
su - "$TARGET_USER" -c "
$TARGET_HOME/.local/bin/toggle-bw --force-off 2>/dev/null || true
gsettings set org.gnome.desktop.interface enable-animations true
gsettings set org.gnome.desktop.sound event-sounds true
gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed true
gsettings reset org.gnome.settings-daemon.plugins.color night-light-enabled
gsettings reset org.gnome.desktop.background picture-uri
gsettings reset org.gnome.desktop.background picture-uri-dark
gsettings reset org.gnome.desktop.background primary-color
" 2>/dev/null || true

# 7. Remove desktop icons
rm -f "$TARGET_HOME/Desktop/online-class-mode.desktop"
rm -f "$TARGET_HOME/Desktop/study-fb.desktop"
rm -f "$TARGET_HOME/Desktop/study-reddit.desktop"
rm -f "$TARGET_HOME/Desktop/study-browser.desktop"
rm -f "$TARGET_HOME/.local/share/applications/online-class-mode.desktop"
rm -f "$TARGET_HOME/.local/share/applications/study-fb.desktop"
rm -f "$TARGET_HOME/.local/share/applications/study-reddit.desktop"
rm -f "$TARGET_HOME/.local/share/applications/study-browser.desktop"

echo "[✓] All settings restored to normal Ubuntu defaults."
