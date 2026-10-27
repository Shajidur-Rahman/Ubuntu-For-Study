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

# 2. Restore /etc/hosts & remove blocklists
chattr -i /etc/hosts /etc/hosts.master 2>/dev/null || true
rm -f /etc/hosts.master
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

# 4. Remove browser policies & unblock all websites
rm -f /etc/opt/chrome/policies/managed/study-restrictions.json
rm -f /etc/brave/policies/managed/study-restrictions.json
rm -f /etc/chromium/policies/managed/study-restrictions.json
rm -f /etc/firefox/policies/policies.json
rm -f /var/snap/firefox/current/policies/policies.json 2>/dev/null || true

# 5. Remove daemon, services & local study scripts
rm -f /etc/sudoers.d/study-timer
rm -f /usr/local/bin/study-timer-daemon /usr/local/bin/study-fb-daemon
rm -f /usr/local/bin/study-fb /usr/local/bin/study-reddit /usr/local/bin/toggle-bw /usr/local/bin/focus /usr/local/bin/study-browser
rm -f /usr/local/bin/hsc_math_engine.py /usr/local/bin/study_lockout.py /usr/local/bin/study-screen-listener
rm -f /usr/local/bin/brave /usr/local/bin/brave-browser /usr/local/bin/brave-browser-stable
rm -f /usr/local/bin/google-chrome /usr/local/bin/google-chrome-stable
rm -rf /etc/study-timer /usr/share/study-browser "$TARGET_HOME/.config/study-browser"
rm -f /lib/systemd/system-sleep/study-resume-grayscale.sh
rm -f "$TARGET_HOME/.config/systemd/user/study-screen-listener.service"
rm -f "$TARGET_HOME/.config/systemd/user/study-extension-server.service"
rm -f "$TARGET_HOME/.local/bin/study-screen-listener" "$TARGET_HOME/.local/bin/toggle-bw" "$TARGET_HOME/.local/bin/study-browser" "$TARGET_HOME/.local/bin/focus" "$TARGET_HOME/.local/bin/study-fb" "$TARGET_HOME/.local/bin/study-reddit"
rm -f "$TARGET_HOME/.local/bin/brave" "$TARGET_HOME/.local/bin/brave-browser" "$TARGET_HOME/.local/bin/brave-browser-stable"
rm -f "$TARGET_HOME/.local/bin/google-chrome" "$TARGET_HOME/.local/bin/google-chrome-stable"
rm -f "$TARGET_HOME/.local/bin/hsc_math_engine.py" "$TARGET_HOME/.local/bin/study_lockout.py"
rm -f "$TARGET_HOME/.local/share/applications/brave-browser.desktop" "$TARGET_HOME/.local/share/applications/google-chrome.desktop"
su - "$TARGET_USER" -c "systemctl --user disable --now study-screen-listener.service study-extension-server.service" 2>/dev/null || true
su - "$TARGET_USER" -c "systemctl --user daemon-reload" 2>/dev/null || true

# 6. Restore Color & Desktop settings
su - "$TARGET_USER" -c "
SCHEMA_DIR=\"$TARGET_HOME/.local/share/gnome-shell/extensions/gnomebedtime@ionutbortis.gmail.com/schemas/\"
if [ -d \"\$SCHEMA_DIR\" ]; then
    gsettings --schemadir \"\$SCHEMA_DIR\" set org.gnome.shell.extensions.bedtime-mode bedtime-mode-active false 2>/dev/null || true
fi
gsettings set org.gnome.desktop.interface enable-animations true
gsettings set org.gnome.desktop.sound event-sounds true
gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed true
gsettings reset org.gnome.settings-daemon.plugins.color night-light-enabled
gsettings reset org.gnome.settings-daemon.plugins.color night-light-schedule-automatic
gsettings reset org.gnome.settings-daemon.plugins.color night-light-temperature
gsettings reset org.gnome.settings-daemon.plugins.media-keys custom-keybindings
gsettings set org.gnome.desktop.background picture-uri 'file:///usr/share/backgrounds/warty-final-ubuntu.png'
gsettings set org.gnome.desktop.background picture-uri-dark 'file:///usr/share/backgrounds/warty-final-ubuntu.png'
gsettings set org.gnome.desktop.background picture-options 'zoom'
gsettings set org.gnome.desktop.background primary-color '#1e1e1e'
" 2>/dev/null || true

# 7. Remove desktop icons & launchers
rm -f "$TARGET_HOME/Desktop/online-class-mode.desktop"
rm -f "$TARGET_HOME/Desktop/study-fb.desktop"
rm -f "$TARGET_HOME/Desktop/study-reddit.desktop"
rm -f "$TARGET_HOME/Desktop/study-browser.desktop"
rm -f "$TARGET_HOME/.local/share/applications/online-class-mode.desktop"
rm -f "$TARGET_HOME/.local/share/applications/study-fb.desktop"
rm -f "$TARGET_HOME/.local/share/applications/study-reddit.desktop"
rm -f "$TARGET_HOME/.local/share/applications/study-browser.desktop"
su - "$TARGET_USER" -c "update-desktop-database '$TARGET_HOME/.local/share/applications'" 2>/dev/null || true

echo "[✓] All blocked sites and restrictions removed. Restored to normal Ubuntu defaults."
