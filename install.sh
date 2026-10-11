#!/usr/bin/env bash
# ==============================================================================
# Ubuntu-For-Study: Complete Distraction-Free Study PC Installer
# Repository: https://github.com/Shajidur-Rahman/Ubuntu-For-Study.git
# Supported OS: Ubuntu 22.04 / 24.04 LTS (GNOME)
# ==============================================================================
set -e

# Detect target normal user (even when run via sudo/pkexec)
if [ -n "$SUDO_USER" ] && [ "$SUDO_USER" != "root" ]; then
    TARGET_USER="$SUDO_USER"
elif [ -n "$PKEXEC_UID" ]; then
    TARGET_USER=$(id -nu "$PKEXEC_UID")
else
    # Find first user with UID >= 1000
    TARGET_USER=$(id -un 1000 2>/dev/null || who | awk 'NR==1{print $1}')
fi

TARGET_HOME=$(getent passwd "$TARGET_USER" | cut -d: -f6)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "================================================================="
echo "       UBUNTU-FOR-STUDY: AUTOMATED SYSTEM INSTALLER"
echo "================================================================="
echo " Target user: $TARGET_USER"
echo " User home:   $TARGET_HOME"
echo "================================================================="

# Require sudo / root privileges
if [ "$EUID" -ne 0 ]; then
    echo "[!] Requesting root privileges..."
    exec sudo bash "$0" "$@"
fi

# ------------------------------------------------------------------------------
# 1. Self-Bootstrap: Download files if run via curl / pipe
# ------------------------------------------------------------------------------
REPO_TAR_URL="https://github.com/Shajidur-Rahman/Ubuntu-For-Study/archive/refs/heads/main.tar.gz"
REPO_RAW_URL="https://raw.githubusercontent.com/Shajidur-Rahman/Ubuntu-For-Study/main"
TMP_DIR="/tmp/ubuntu-for-study-bootstrap"

if [ ! -d "$SCRIPT_DIR/scripts" ]; then
    echo "[1/8] Running from remote pipe. Fetching full repository package..."
    rm -rf "$TMP_DIR"
    mkdir -p "$TMP_DIR"
    
    if curl -fsSL "$REPO_TAR_URL" 2>/dev/null | tar -xz -C "$TMP_DIR" --strip-components=1 2>/dev/null; then
        echo "  [✓] Repository package downloaded and unpacked successfully."
        SCRIPT_DIR="$TMP_DIR"
    else
        echo "  [!] Downloading individual core files..."
        mkdir -p "$TMP_DIR/scripts" "$TMP_DIR/desktop"
        FILES=(
            "scripts/study-timer-daemon.py"
            "scripts/hsc_math_engine.py"
            "scripts/study_lockout.py"
            "scripts/study-fb"
            "scripts/study-reddit"
            "scripts/toggle-bw"
            "scripts/study-screen-listener"
            "scripts/study-resume-grayscale.sh"
            "scripts/focus"
            "desktop/online-class-mode.desktop"
            "desktop/study-fb.desktop"
            "desktop/study-reddit.desktop"
            "uninstall.sh"
        )
        for f in "${FILES[@]}"; do
            echo "    Fetching $f..."
            curl -fsSL "$REPO_RAW_URL/$f" -o "$TMP_DIR/$f" || true
        done
        SCRIPT_DIR="$TMP_DIR"
    fi
fi

# ------------------------------------------------------------------------------
# 2. System Dependencies
# ------------------------------------------------------------------------------
echo "[2/8] Checking system dependencies..."
apt-get update -qq
apt-get install -y -qq curl python3 unzip e2fsprogs gnome-shell-extension-manager libglib2.0-bin-user >/dev/null

# ------------------------------------------------------------------------------
# 3. 3-Tier Network & Adult Filter (Hosts + Cloudflare Family DNS)
# ------------------------------------------------------------------------------
echo "[3/8] Building 150,000+ domain adult & distraction sinkhole..."

BACKUP_DIR="/etc/study-mode-backup"
mkdir -p "$BACKUP_DIR"
[ ! -f "$BACKUP_DIR/hosts.bak" ] && cp /etc/hosts "$BACKUP_DIR/hosts.bak"

TMP_HOSTS=$(mktemp)
cat << 'EOF' > "$TMP_HOSTS"
# ===============================================================
# Ubuntu-For-Study Base System Hosts
# ===============================================================
127.0.0.1 localhost localhost.localdomain local
::1 localhost ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
ff02::3 ip6-allhosts
0.0.0.0 0.0.0.0

# Core Distractions (Permanent Block)
0.0.0.0 instagram.com www.instagram.com cdninstagram.com threads.net www.threads.net
0.0.0.0 tiktok.com www.tiktok.com
0.0.0.0 twitter.com www.twitter.com x.com www.x.com t.co
0.0.0.0 snapchat.com www.snapchat.com
0.0.0.0 twitch.tv www.twitch.tv pinterest.com www.pinterest.com

# DoH Bypass Canaries
0.0.0.0 use-application-dns.net
0.0.0.0 doh.dns.apple.com

# Facebook Base (Locked by default)
0.0.0.0 facebook.com www.facebook.com m.facebook.com l.facebook.com
0.0.0.0 fb.com www.fb.com messenger.com www.messenger.com

# Reddit Base (Locked by default)
0.0.0.0 reddit.com www.reddit.com old.reddit.com redd.it
EOF

echo "  Downloading StevenBlack porn-social blocklist..."
curl -fsSL --connect-timeout 15 "https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/porn-social/hosts" >> "$TMP_HOSTS" 2>/dev/null || true

# Whitelist WhatsApp so messaging works
sed -i '/whatsapp/d' "$TMP_HOSTS"

cp "$TMP_HOSTS" /etc/hosts.master
rm -f "$TMP_HOSTS"

# Configure Encrypted Family DNS (systemd-resolved)
mkdir -p /etc/systemd/resolved.conf.d
cat << 'EOF' > /etc/systemd/resolved.conf.d/strict-study-dns.conf
[Resolve]
DNS=1.1.1.3 1.0.0.3 2606:4700:4700::1113 2606:4700:4700::1003
FallbackDNS=185.228.168.168 185.228.169.168
Domains=~.
DNSOverTLS=no
DNSSEC=no
Cache=yes
EOF

systemctl restart systemd-resolved
resolvectl flush-caches 2>/dev/null || true

# ------------------------------------------------------------------------------
# 4. Browser Enterprise Hardening (Chrome, Brave, Firefox)
# ------------------------------------------------------------------------------
echo "[4/8] Enforcing browser enterprise policies..."

CHROME_POLICY_DIR="/etc/opt/chrome/policies/managed"
BRAVE_POLICY_DIR="/etc/brave/policies/managed"
FIREFOX_POLICY_DIR="/etc/firefox/policies"
mkdir -p "$CHROME_POLICY_DIR" "$BRAVE_POLICY_DIR" "$FIREFOX_POLICY_DIR"

cat << 'EOF' > "$CHROME_POLICY_DIR/study-restrictions.json"
{
  "IncognitoModeAvailability": 1,
  "ForceGoogleSafeSearch": true,
  "ForceYouTubeSafetyMode": true,
  "DnsOverHttpsMode": "off",
  "SearchSuggestEnabled": false,
  "AutoplayAllowed": false,
  "NewTabPageLocation": "about:blank",
  "URLBlocklist": [
    "*://*.instagram.com/*",
    "*://*.threads.net/*",
    "*://*.tiktok.com/*",
    "*://*.twitter.com/*",
    "*://*.x.com/*",
    "*://*.snapchat.com/*",
    "*://*.twitch.tv/*"
  ]
}
EOF
cp "$CHROME_POLICY_DIR/study-restrictions.json" "$BRAVE_POLICY_DIR/study-restrictions.json"

cat << 'EOF' > "$FIREFOX_POLICY_DIR/policies.json"
{
  "policies": {
    "DisablePrivateBrowsing": true,
    "SearchSuggestEnabled": false,
    "Homepage": {"URL": "about:blank", "StartPage": "blank"},
    "NewTabPage": false,
    "DNSOverHTTPS": {"Enabled": false, "Locked": true},
    "WebsiteFilter": {
      "Block": [
        "*://*.instagram.com/*",
        "*://*.threads.net/*",
        "*://*.tiktok.com/*",
        "*://*.twitter.com/*",
        "*://*.x.com/*",
        "*://*.snapchat.com/*",
        "*://*.twitch.tv/*"
      ]
    }
  }
}
EOF

# Firefox snap support
if [ -d "/var/snap/firefox/current" ]; then
    mkdir -p "/var/snap/firefox/current/policies"
    cp "$FIREFOX_POLICY_DIR/policies.json" "/var/snap/firefox/current/policies/policies.json"
fi

# ------------------------------------------------------------------------------
# 5. Core Scripts & Self-Healing Daemon
# ------------------------------------------------------------------------------
echo "[5/8] Installing core binaries and self-healing guardian..."

BIN_DIR="/usr/local/bin"
USER_BIN="$TARGET_HOME/.local/bin"
STATE_DIR="/etc/study-timer"
mkdir -p "$BIN_DIR" "$USER_BIN" "$STATE_DIR"

# Install daemon & scripts system-wide
cp "$SCRIPT_DIR/scripts/study-timer-daemon.py" "$BIN_DIR/study-timer-daemon"
chmod 755 "$BIN_DIR/study-timer-daemon"
ln -sf "$BIN_DIR/study-timer-daemon" "$BIN_DIR/study-fb-daemon"

ALL_SCRIPTS=("study-fb" "study-reddit" "hsc_math_engine.py" "study_lockout.py" "toggle-bw" "focus" "study-screen-listener")
for s in "${ALL_SCRIPTS[@]}"; do
    if [ -f "$SCRIPT_DIR/scripts/$s" ]; then
        cp "$SCRIPT_DIR/scripts/$s" "$BIN_DIR/$s"
        chmod 755 "$BIN_DIR/$s"
        cp "$SCRIPT_DIR/scripts/$s" "$USER_BIN/$s"
        chown "$TARGET_USER:$TARGET_USER" "$USER_BIN/$s"
        chmod 755 "$USER_BIN/$s"
    fi
done

# Configure passwordless sudo for study daemon
cat << EOF > /etc/sudoers.d/study-timer
$TARGET_USER ALL=(ALL) NOPASSWD: /usr/local/bin/study-timer-daemon
$TARGET_USER ALL=(ALL) NOPASSWD: /usr/local/bin/study-fb-daemon
%sudo ALL=(ALL) NOPASSWD: /usr/local/bin/study-timer-daemon
%sudo ALL=(ALL) NOPASSWD: /usr/local/bin/study-fb-daemon
EOF
chmod 440 /etc/sudoers.d/study-timer
visudo -cf /etc/sudoers.d/study-timer

# Install Self-Healing Guardian systemd service
cat << 'EOF' > /etc/systemd/system/study-guardian.service
[Unit]
Description=Ubuntu-For-Study Self-Healing Watchdog & Policy Guardian
After=network.target systemd-resolved.service

[Service]
Type=simple
ExecStart=/usr/local/bin/study-timer-daemon watchdog
Restart=always
RestartSec=5
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now study-guardian.service

# Run initial sync
"$BIN_DIR/study-timer-daemon" sync

# ------------------------------------------------------------------------------
# 6. Grayscale Bedtime Mode & Sleep/Unlock Auto-Healers
# ------------------------------------------------------------------------------
echo "[6/8] Configuring Grayscale Bedtime Mode and sleep wake hooks..."

EXT_DIR="$TARGET_HOME/.local/share/gnome-shell/extensions/gnomebedtime@ionutbortis.gmail.com"
if [ ! -d "$EXT_DIR" ]; then
    echo "  Installing Bedtime Mode extension..."
    mkdir -p "$EXT_DIR"
    curl -fsSL "https://github.com/ionutbortis/gnome-bedtime-mode/releases/download/v19.0/gnome-bedtime-mode_19.0.zip" -o /tmp/bedtime.zip
    unzip -qo /tmp/bedtime.zip -d "$EXT_DIR"
    rm -f /tmp/bedtime.zip
    chown -R "$TARGET_USER:$TARGET_USER" "$EXT_DIR"
fi

glib-compile-schemas "$EXT_DIR/schemas" 2>/dev/null || true
su - "$TARGET_USER" -c "gnome-extensions enable gnomebedtime@ionutbortis.gmail.com" 2>/dev/null || true

# Systemd suspend/resume hook (re-applies grayscale on waking from sleep)
mkdir -p /lib/systemd/system-sleep
if [ -f "$SCRIPT_DIR/scripts/study-resume-grayscale.sh" ]; then
    cp "$SCRIPT_DIR/scripts/study-resume-grayscale.sh" /lib/systemd/system-sleep/study-resume-grayscale.sh
else
    cat << EOF > /lib/systemd/system-sleep/study-resume-grayscale.sh
#!/bin/sh
case "\$1" in
    post)
        sleep 1.5
        su - $TARGET_USER -c "$USER_BIN/toggle-bw --force-on" >/dev/null 2>&1 &
        ;;
esac
EOF
fi
chmod 755 /lib/systemd/system-sleep/study-resume-grayscale.sh

# User screen unlock listener service
USER_SYSTEMD="$TARGET_HOME/.config/systemd/user"
mkdir -p "$USER_SYSTEMD"
cat << EOF > "$USER_SYSTEMD/study-screen-listener.service"
[Unit]
Description=Ensure Grayscale Study Mode on Screen Unlock
After=graphical-session.target

[Service]
Type=simple
ExecStart=$USER_BIN/study-screen-listener
Restart=always
RestartSec=3

[Install]
WantedBy=default.target
EOF

chown -R "$TARGET_USER:$TARGET_USER" "$TARGET_HOME/.config"
su - "$TARGET_USER" -c "systemctl --user daemon-reload && systemctl --user enable --now study-screen-listener.service" 2>/dev/null || true

# Force grayscale active now
su - "$TARGET_USER" -c "$USER_BIN/toggle-bw --force-on" 2>/dev/null || true

# Register Super+Alt+B keyboard shortcut for Online Class toggle
su - "$TARGET_USER" -c "gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings \"['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']\"" 2>/dev/null || true
su - "$TARGET_USER" -c "gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name 'Toggle Grayscale'" 2>/dev/null || true
su - "$TARGET_USER" -c "gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command '/usr/local/bin/toggle-bw'" 2>/dev/null || true
su - "$TARGET_USER" -c "gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding '<Super><Alt>b'" 2>/dev/null || true

# ------------------------------------------------------------------------------
# 7. Desktop Launchers
# ------------------------------------------------------------------------------
echo "[7/8] Deploying desktop launchers..."

APP_DIR="$TARGET_HOME/.local/share/applications"
DESKTOP_DIR="$TARGET_HOME/Desktop"
mkdir -p "$APP_DIR" "$DESKTOP_DIR"

LAUNCHERS=("online-class-mode.desktop" "study-fb.desktop" "study-reddit.desktop")
for l in "${LAUNCHERS[@]}"; do
    if [ -f "$SCRIPT_DIR/desktop/$l" ]; then
        cp "$SCRIPT_DIR/desktop/$l" "$APP_DIR/$l"
        cp "$SCRIPT_DIR/desktop/$l" "$DESKTOP_DIR/$l"
        chown "$TARGET_USER:$TARGET_USER" "$APP_DIR/$l" "$DESKTOP_DIR/$l"
        chmod +x "$APP_DIR/$l" "$DESKTOP_DIR/$l"
        su - "$TARGET_USER" -c "gio set '$DESKTOP_DIR/$l' metadata::trusted true" 2>/dev/null || true
    fi
done

su - "$TARGET_USER" -c "update-desktop-database '$APP_DIR'" 2>/dev/null || true

# ------------------------------------------------------------------------------
# 8. Dopamine Detox Desktop Settings
# ------------------------------------------------------------------------------
echo "[8/8] Applying dopamine detox settings..."

su - "$TARGET_USER" -c "
gsettings set org.gnome.desktop.interface enable-animations false
gsettings set org.gnome.desktop.sound event-sounds false
gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false
gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true
gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-automatic false
gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-from 0.0
gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-to 24.0
gsettings set org.gnome.settings-daemon.plugins.color night-light-temperature 4000
gsettings set org.gnome.desktop.background picture-uri ''
gsettings set org.gnome.desktop.background picture-uri-dark ''
gsettings set org.gnome.desktop.background color-shading-type 'solid'
gsettings set org.gnome.desktop.background primary-color '#1e1e1e'
" 2>/dev/null || true

echo "================================================================="
echo "  [✓] INSTALLATION COMPLETE! YOUR PC IS A STRICT STUDY MACHINE."
echo "================================================================="
echo "  - Grayscale: Active 24/7 (Restores automatically on sleep/wake)"
echo "  - Online Class: Click 'Online Class Mode' or press Super+Alt+B"
echo "  - Study Groups: Use 'study-fb' or 'study-reddit' on Desktop"
echo "  - Self-Healing Guardian: Active as systemd service (auto-recovers)"
echo "  - All adult content & addictive feeds: Strictly blocked 24/7"
echo "================================================================="
