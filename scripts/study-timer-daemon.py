#!/usr/bin/env python3
import sys
import os
import time
import json
import subprocess
import re

MASTER_HOSTS = "/etc/hosts.master"
CURRENT_HOSTS = "/etc/hosts"
CHROME_POLICY = "/etc/opt/chrome/policies/managed/study-restrictions.json"
BRAVE_POLICY = "/etc/brave/policies/managed/study-restrictions.json"
STATE_DIR = "/etc/study-timer"

os.makedirs(STATE_DIR, exist_ok=True)

FB_TIMESTAMP = os.path.join(STATE_DIR, "fb.timestamp")
REDDIT_TIMESTAMP = os.path.join(STATE_DIR, "reddit.timestamp")

BASE_BLOCKED_URLS = [
    # Social & Addictive Feeds
    "*://*.instagram.com/*",
    "*://*.threads.net/*",
    "*://*.tiktok.com/*",
    "*://*.twitter.com/*",
    "*://*.x.com/*",
    "*://*.snapchat.com/*",
    "*://*.twitch.tv/*",

    # Regional & South Asian Adult/Leak Networks (Bengali, Desi, MMS)
    "*://*mmsgram*/*",
    "*://*mmsleak*/*",
    "*://*mmsbee*/*",
    "*://*desimms*/*",
    "*://*banglachoti*/*",
    "*://*choti*/*",
    "*://*banglasex*/*",
    "*://*desisex*/*",
    "*://*bhabhi*/*",
    "*://*antarchoti*/*",

    # Global Adult Tubes, Webcams & OnlyFans Leaks
    "*://*porn*/*",
    "*://*xxx*/*",
    "*://*xnxx*/*",
    "*://*xvideos*/*",
    "*://*xhamster*/*",
    "*://*redtube*/*",
    "*://*youporn*/*",
    "*://*pornhub*/*",
    "*://*spankbang*/*",
    "*://*beeg*/*",
    "*://*tnaflix*/*",
    "*://*eporner*/*",
    "*://*txxx*/*",
    "*://*tube8*/*",
    "*://*stripchat*/*",
    "*://*chaturbate*/*",
    "*://*bongacams*/*",
    "*://*cam4*/*",
    "*://*camsoda*/*",
    "*://*livejasmin*/*",
    "*://*myfreecams*/*",
    "*://*streamate*/*",
    "*://*onlyfans*/*",
    "*://*fansly*/*",
    "*://*manyvids*/*",
    "*://*fapello*/*",
    "*://*erome*/*",
    "*://*coomer*/*",
    "*://*kemono*/*",
    "*://*thothub*/*",
    "*://*hentai*/*",
    "*://*nude*/*",
    "*://*erotic*/*",
    "*://*motherless*/*",
    "*://*rule34*/*",
    "*://*brazzers*/*",
    "*://*bangbros*/*",
    "*://*naughtyamerica*/*",
    "*://*realitykings*/*",
    "*://*vixen*/*",
    "*://*blacked*/*",
    "*://*tushy*/*"
]

def get_desktop_user_info():
    """Dynamically determine active graphical desktop user and UID."""
    try:
        res = subprocess.run(["loginctl", "list-sessions", "--no-legend"], capture_output=True, text=True)
        for line in res.stdout.strip().splitlines():
            parts = line.split()
            if len(parts) >= 3:
                sess_id, uid, user = parts[0], parts[1], parts[2]
                if int(uid) >= 1000 and user != "root":
                    return user, uid
    except Exception:
        pass

    sudo_user = os.environ.get("SUDO_USER")
    if sudo_user and sudo_user != "root":
        import pwd
        try:
            uid = pwd.getpwnam(sudo_user).pw_uid
            return sudo_user, str(uid)
        except Exception:
            pass

    import pwd
    for p in pwd.getpwall():
        if 1000 <= p.pw_uid < 60000 and os.path.exists(p.pw_dir):
            return p.pw_name, str(p.pw_uid)

    return "dan-brown", "1000"

def is_active(ts_file):
    """Checks if a timestamp unlock is currently active."""
    if not os.path.exists(ts_file):
        return False, 0
    try:
        with open(ts_file, "r") as f:
            lines = [l.strip() for l in f if l.strip()]
        if len(lines) < 2:
            return False, 0
        start = int(lines[0])
        dur = int(lines[1])
        now = int(time.time())
        rem = (start + dur) - now
        if rem > 0:
            return True, rem
        return False, 0
    except Exception:
        return False, 0

def sync():
    """Synchronizes /etc/hosts, browser policies, and flushes DNS caches."""
    fb_unlocked, _ = is_active(FB_TIMESTAMP)
    reddit_unlocked, _ = is_active(REDDIT_TIMESTAMP)

    patterns = []
    if fb_unlocked:
        patterns.append(r"(facebook|fbcdn|fbsbx|fb\.com|messenger)")
    if reddit_unlocked:
        patterns.append(r"(reddit|redd\.it)")

    regex = None
    if patterns:
        combined = "|".join(patterns)
        regex = re.compile(combined, re.IGNORECASE)

    # Ensure master hosts exists
    if not os.path.exists(MASTER_HOSTS):
        subprocess.run(["cp", CURRENT_HOSTS, MASTER_HOSTS])

    with open(MASTER_HOSTS, "r", encoding="utf-8", errors="ignore") as f:
        master_lines = f.readlines()

    if regex:
        # Whitelist unlocked services while preserving adult keyword blocks
        filtered_lines = []
        for line in master_lines:
            if regex.search(line):
                lower = line.lower()
                if "porn" in lower or "incest" in lower or "nsfw" in lower or "sex" in lower:
                    filtered_lines.append(line)
            else:
                filtered_lines.append(line)
    else:
        filtered_lines = master_lines

    # Write to /etc/hosts safely
    subprocess.run(["chattr", "-i", CURRENT_HOSTS], stderr=subprocess.DEVNULL)
    with open(CURRENT_HOSTS, "w", encoding="utf-8") as f:
        f.writelines(filtered_lines)
    subprocess.run(["chattr", "+i", CURRENT_HOSTS], stderr=subprocess.DEVNULL)

    # Chrome / Brave policy sync: Enforce identical strict policy across all Chromium browsers
    unified_blocklist = list(BASE_BLOCKED_URLS) + [
        "*://*.youtube.com/shorts/*",
        "*://*.youtu.be/shorts/*",
        "*://*.facebook.com/*"
    ]
    unified_allowlist = [
        "https://www.facebook.com/groups/fabzoology27/*",
        "https://www.facebook.com/groups/fabbotany27/*",
        "https://www.facebook.com/groups/1612120089807832/*",
        "https://www.facebook.com/groups/saikatvaisengineeringchemistryhsc26/*",
        "https://www.facebook.com/login/*",
        "https://www.facebook.com/checkpoint/*",
        "https://www.facebook.com/two_factor/*",
        "https://www.facebook.com/recover/*",
        "https://www.facebook.com/auth/*",
        "*://*.fbcdn.net/*",
        "*://*.fbsbx.com/*"
    ]

    CHROMIUM_POLICY = "/etc/chromium/policies/managed/study-restrictions.json"
    for pol_path in [CHROME_POLICY, BRAVE_POLICY, CHROMIUM_POLICY]:
        try:
            os.makedirs(os.path.dirname(pol_path), exist_ok=True)
            data = {}
            if os.path.exists(pol_path):
                with open(pol_path, "r") as f:
                    data = json.load(f)
            data["IncognitoModeAvailability"] = 1
            data["ForceGoogleSafeSearch"] = True
            data["ForceYouTubeSafetyMode"] = True
            data["DnsOverHttpsMode"] = "off"
            data["BackgroundModeEnabled"] = False
            data["URLBlocklist"] = unified_blocklist
            data["URLAllowlist"] = unified_allowlist
            data["ExtensionInstallSources"] = ["http://127.0.0.1:49152/*"]
            data["ExtensionInstallForcelist"] = ["kmipjahpplnmohdfjbdbfdopdlpbapnn;http://127.0.0.1:49152/updates.xml"]
            data["SearchSuggestEnabled"] = False
            data["AutoplayAllowed"] = False
            data["NewTabPageLocation"] = "about:blank"
            with open(pol_path, "w") as f:
                json.dump(data, f, indent=2)
        except Exception:
            pass

    # Flush DNS caches
    subprocess.run(["resolvectl", "flush-caches"], stderr=subprocess.DEVNULL)

def notify_user(title, message, urgency="normal"):
    """Send desktop notification to the user."""
    user, uid = get_desktop_user_info()
    env = os.environ.copy()
    env["DISPLAY"] = ":0"
    env["WAYLAND_DISPLAY"] = "wayland-0"
    env["DBUS_SESSION_BUS_ADDRESS"] = f"unix:path=/run/user/{uid}/bus"
    subprocess.run([
        "su", "-", user, "-c",
        f"notify-send -u {urgency} -i accessories-calculator '{title}' '{message}'"
    ], env=env, stderr=subprocess.DEVNULL)

def daemon_timer(service, minutes):
    """Background process countdown timer for unlock."""
    seconds = minutes * 60
    name = service.capitalize()

    notify_user(f"{name} Study Access", f"{name} is unlocked for {minutes} minutes. Use it wisely!")

    if seconds > 60:
        time.sleep(seconds - 60)
        notify_user(f"{name} Study Access", f"WARNING: 1 minute remaining before {name} is locked!", urgency="critical")
        time.sleep(60)
    else:
        time.sleep(seconds)

    # Lock service
    ts_file = FB_TIMESTAMP if service == "facebook" else REDDIT_TIMESTAMP
    if os.path.exists(ts_file):
        try:
            os.remove(ts_file)
        except Exception:
            pass

    sync()
    notify_user(f"{name} Study Access", f"TIME IS UP! {name} has been locked. Back to studying!", urgency="critical")

def verify_hosts_integrity():
    """Self-healing: Ensures /etc/hosts is intact, immutable, and contains study blocks."""
    if not os.path.exists(CURRENT_HOSTS):
        sync()
        return

    try:
        with open(CURRENT_HOSTS, "r", encoding="utf-8", errors="ignore") as f:
            content = f.read()
        # Verify key baseline blocked domains exist
        if "instagram.com" not in content or "tiktok.com" not in content:
            sync()
            return
    except Exception:
        sync()
        return

    # Ensure immutable flag (+i) is enabled
    try:
        res = subprocess.run(["lsattr", CURRENT_HOSTS], capture_output=True, text=True)
        if "i" not in res.stdout.split()[0]:
            subprocess.run(["chattr", "+i", CURRENT_HOSTS], stderr=subprocess.DEVNULL)
    except Exception:
        pass

def watchdog():
    """Intelligent Self-Healing Guardian Loop."""
    print("[✓] Ubuntu-For-Study Self-Healing Guardian Active.")
    # Immediate boot/restart sync
    sync()

    while True:
        try:
            time.sleep(10)
            now = int(time.time())

            # 1. Check Facebook timer expiration
            if os.path.exists(FB_TIMESTAMP):
                active, rem = is_active(FB_TIMESTAMP)
                if not active:
                    try:
                        os.remove(FB_TIMESTAMP)
                    except Exception:
                        pass
                    sync()
                    notify_user("Facebook Access Expired", "14-minute study window has ended. Facebook is locked.", urgency="critical")

            # 2. Check Reddit timer expiration
            if os.path.exists(REDDIT_TIMESTAMP):
                active, rem = is_active(REDDIT_TIMESTAMP)
                if not active:
                    try:
                        os.remove(REDDIT_TIMESTAMP)
                    except Exception:
                        pass
                    sync()
                    notify_user("Reddit Access Expired", "14-minute study window has ended. Reddit is locked.", urgency="critical")

            # 3. Verify /etc/hosts integrity
            verify_hosts_integrity()

            # 4. Verify systemd-resolved DNS daemon health
            resolved_check = subprocess.run(["systemctl", "is-active", "--quiet", "systemd-resolved"])
            if resolved_check.returncode != 0:
                subprocess.run(["systemctl", "restart", "systemd-resolved"], stderr=subprocess.DEVNULL)

        except Exception as e:
            # Catch unexpected issues, brief sleep, and resume without dying
            time.sleep(5)

def main():
    if len(sys.argv) < 2:
        print("Usage: study-timer-daemon [unlock <service> <minutes> | lock <service> | status <service> | sync | watchdog]")
        sys.exit(1)

    cmd = sys.argv[1].lower()

    if cmd == "watchdog":
        watchdog()
        return

    service = "facebook"
    if len(sys.argv) >= 3 and sys.argv[2] in ["facebook", "reddit"]:
        service = sys.argv[2]
    elif len(sys.argv) >= 3 and sys.argv[2].isdigit():
        service = "facebook"

    ts_file = FB_TIMESTAMP if service == "facebook" else REDDIT_TIMESTAMP

    if cmd == "unlock":
        mins = 14
        if len(sys.argv) >= 4 and sys.argv[3].isdigit():
            mins = int(sys.argv[3])
        elif len(sys.argv) >= 3 and sys.argv[2].isdigit():
            mins = int(sys.argv[2])

        now = int(time.time())
        duration = mins * 60
        with open(ts_file, "w") as f:
            f.write(f"{now}\n{duration}\n")

        sync()

        # Fork background timer
        pid = os.fork()
        if pid == 0:
            os.setsid()
            daemon_timer(service, mins)
            sys.exit(0)
        else:
            print(f"[✓] {service.capitalize()} unlocked for {mins} minutes.")

    elif cmd == "lock":
        if os.path.exists(ts_file):
            try:
                os.remove(ts_file)
            except Exception:
                pass
        sync()
        print(f"[✓] {service.capitalize()} is now locked.")

    elif cmd == "status":
        active, rem = is_active(ts_file)
        if active:
            m = rem // 60
            s = rem % 60
            print(f"UNLOCKED: {m}m {s}s remaining")
        else:
            print("LOCKED")

    elif cmd == "sync":
        sync()
        print("[✓] Synchronized hosts and policies.")

if __name__ == "__main__":
    main()
