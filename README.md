# 📚 Ubuntu-For-Study

Turn your Ubuntu 22.04 / 24.04 LTS (GNOME Wayland/X11) workstation into an **uncompromising, distraction-free study machine** engineered for high-stakes exam preparation (HSC & University admissions).

---

## ⚡ 1-Command Automated Installation

Run this single command in your Ubuntu terminal:

```bash
curl -fsSL https://raw.githubusercontent.com/Shajidur-Rahman/Ubuntu-For-Study/main/install.sh | sudo bash
```

*Or via `wget`:*
```bash
wget -qO- https://raw.githubusercontent.com/Shajidur-Rahman/Ubuntu-For-Study/main/install.sh | sudo bash
```

The installer automatically bootstraps and downloads all dependencies, builds the 150,000+ domain adult & distraction sinkhole, configures family-filtered DNS, hardens browser enterprise policies, installs the self-healing guardian, and activates 24/7 grayscale mode.

---

## 🛡️ Key Features

### 1. 24/7 Adult & Distraction Sinkhole (3-Tier Protection)
* **150,000+ Domain Sinkhole:** Integrates the curated StevenBlack porn-social blocklist to block pornography, adult material, dating sites, and compulsive short-form video.
* **Addictive Platforms Permanently Blocked:** Instagram, Threads, TikTok, Twitter/X, Snapchat, Twitch, and Pinterest are blocked system-wide at `/etc/hosts` and forced via Chrome/Brave/Firefox enterprise policies.
* **Encrypted Family DNS (`systemd-resolved`):** Cloudflare 1.1.1.3 Family DNS with CleanBrowsing fallback. All DoH/DoT bypass canaries are sinkholed to prevent circumvention.
* **Whitelisted for Academics:**
  - `web.whatsapp.com` remains enabled for communication.
  - `youtube.com` remains accessible with Restricted Safety Mode enforced for academic lectures.

---

### 2. Controlled 14-Minute Study Access (Facebook & Reddit)

Facebook and Reddit are blocked by default. Access can only be unlocked for a strict **14-minute window**:

#### 📘 Facebook Study Groups (`study-fb` / Desktop Icon)
* Requires solving a procedural **HSC-level Mathematics challenge** (pen-and-paper calculation, 2–3 minutes):
  - Differentiation (derivative evaluation $f'(x_0)$)
  - Slope of tangent to curves ($\frac{dy}{dx}$ at $x=x_0$)
  - Stationary/critical points ($\frac{dy}{dx} = 0$)
  - Second derivatives ($\frac{d^2y}{dx^2}$)
  - Quadratic roots ($\alpha^2 + \beta^2$)
  - Vector scalar dot products ($\vec{u} \cdot \vec{v}$)
  - $2 \times 2$ determinants
* **3-Strike Lockout Rule:** 3 failed attempts trigger an automatic **30-minute lockout**. No math challenges or access are allowed during the penalty period.

#### 🔴 Reddit Access (`study-reddit` / Desktop Icon)
* Requires solving the HSC mathematics challenge **PLUS** confronting **5 randomized Islamic Conscience Gates** sampled from a library of 20 authentic Quranic verses and Hadiths on:
  - *Al-Muraqabah* (Allah sees all things — Surah Al-'Alaq 96:14)
  - *The stealthy glance* (Surah Ghafir 40:19)
  - *Testimony of hands and eyes* (Surah Ya-Sin 36:65)
  - *Sins committed in seclusion* (Sunan Ibn Majah #4245)
  - *The sacred trust of youth* (Sunan At-Tirmidhi)
  - *The sudden arrival of death* (Surah Al-Mu'minun 23:99)
* You must affirm all 5 prompts with `"yes"`. Any hesitation or refusal immediately aborts access.

---

### 3. Self-Healing Guardian (`study-guardian.service`)

The system includes an intelligent self-repair engine running as a systemd service:
* **Crash-Proof Timer Recovery:** Timers persist in `/etc/study-timer`. If the daemon, browser, or entire PC crashes or reboots while unlocked, the guardian evaluates expiration immediately upon reboot and restores strict blocks.
* **Hosts Integrity Self-Repair:** Constantly verifies `/etc/hosts` against `/etc/hosts.master`. If any blocked domains are tampered with or modified, it restores the master list and locks `/etc/hosts` with immutable attributes (`chattr +i`).
* **DNS Watchdog:** Continuously monitors `systemd-resolved` and revives it automatically if it fails.
* **Auto-Restart:** The guardian service runs with `Restart=always` and boots on startup.

---

### 4. Hardware Grayscale Study Mode (Black & White)
* Operates **24/7** via Clutter shader desaturation (`gnome-bedtime-mode`).
* **Sleep/Wake Resilient:** Auto-restores grayscale upon waking from suspend (`/lib/systemd/system-sleep/study-resume-grayscale.sh`).
* **Screen Unlock Resilient:** Automatically re-applies grayscale whenever the screen is unlocked via DBus listener (`study-screen-listener.service`).
* **Online Class Mode:** Click the **Online Class Mode** desktop icon or press `Super + Alt + B` to temporarily switch to full color for diagrams/lectures. Press again to return to grayscale.

---

### 5. Dopamine Detox Desktop Settings
* **Animations:** Disabled (`enable-animations false`).
* **Audio:** System sounds and event bells muted.
* **Dock:** Auto-hiding (`dash-to-dock dock-fixed false`).
* **Night Light:** 4000K warm tone active 24/7 to protect circadian rhythm and eyes.
* **Wallpaper:** Solid dark gray `#1e1e1e` (zero visual stimulation).
* **Browsers:** Blank new tab page (`about:blank`), search suggestions disabled, incognito/private browsing blocked.

---

## 🛠️ CLI Quick Commands

| Command | Description |
| :--- | :--- |
| `study-fb` | Launch Facebook HSC math challenge (unlocks 14 mins on success) |
| `study-reddit` | Launch Reddit HSC math + 5 Islamic reflection gates (14 mins) |
| `toggle-bw` | Toggle between Grayscale and Full Color (or `toggle-bw --force-on`) |
| `focus [mins]` | Monotasking Pomodoro timer with automatic Do Not Disturb (e.g. `focus 25`) |
| `sudo study-timer-daemon status <service>` | Check remaining unlocked time |
| `sudo study-timer-daemon lock <service>` | Manually lock access early |
| `sudo study-timer-daemon sync` | Force immediate synchronization of hosts & policies |

---

## 🔄 Uninstallation & Full System Restore

To completely restore your Ubuntu system to its original default state:

```bash
git clone https://github.com/Shajidur-Rahman/Ubuntu-For-Study.git
cd Ubuntu-For-Study
sudo bash uninstall.sh
```

---

## 📄 License
MIT License. Created for students seeking discipline, focus, and excellence.
