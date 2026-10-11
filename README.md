<div align="center">

# 🧠 Ubuntu-For-Study
### The Autonomous, Distraction-Free Operating System Environment for Serious Students

[![Ubuntu](https://img.shields.io/badge/Ubuntu-22.04%20%7C%2024.04%20LTS-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)](https://ubuntu.com)
[![GNOME](https://img.shields.io/badge/Desktop-GNOME%2042%20--%2046-4a90d9?style=for-the-badge&logo=gnome&logoColor=white)](https://www.gnome.org)
[![Discipline](https://img.shields.io/badge/Focus-100%25%20Distraction--Free-2ea44f?style=for-the-badge)](https://github.com/Shajidur-Rahman/Ubuntu-For-Study)
[![Self Healing](https://img.shields.io/badge/Guardian-Self--Healing%20Daemon-blueviolet?style=for-the-badge)](https://github.com/Shajidur-Rahman/Ubuntu-For-Study)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](LICENSE)

<br/>

**Transform your standard Ubuntu desktop into a fortress of academic focus.**  
Engineered specifically for HSC, University Admission candidates, and competitive exam takers who cannot afford digital distractions.

[Quick Start](#-one-command-installation) • [Core Philosophy](#-why-ubuntu-for-study) • [Features](#-system-architecture--features) • [Math & Conscience Gates](#-controlled-14-minute-study-access) • [CLI Commands](#-command-line-reference) • [Self-Healing](#-intelligent-self-healing--crash-recovery)

<hr/>

</div>

## ⚡ One-Command Installation

Run this single command in your terminal. The script will automatically download the required files, configure network filters, harden browser policies, deploy the self-healing daemon, and activate hardware grayscale:

```bash
curl -fsSL https://raw.githubusercontent.com/Shajidur-Rahman/Ubuntu-For-Study/main/install.sh | sudo bash
```

> **Alternative via `wget`:**
> ```bash
> wget -qO- https://raw.githubusercontent.com/Shajidur-Rahman/Ubuntu-For-Study/main/install.sh | sudo bash
> ```

---

## 💡 Why Ubuntu-For-Study?

Willpower is finite. When studying for competitive examinations, modern web platforms deploy multi-billion dollar algorithms designed to exploit human dopamine pathways. Standard app blockers are easily bypassed with a single toggle or private window.

**Ubuntu-For-Study eliminates reliance on willpower through immutable system-level guardrails:**

| Feature | Standard Ubuntu Setup | Ubuntu-For-Study |
| :--- | :--- | :--- |
| **Color Spectrum** | 16.7M vivid, hyper-stimulating colors | **24/7 Hardware Grayscale** (Restores automatically on sleep/wake) |
| **Adult Content & Porn** | Open access via DNS/Incognito | **150,000+ domain sinkhole** + Cloudflare Family DNS + Immutable hosts |
| **Short-Form Feeds (Reels/TikTok/X)** | Algorithmic rabbit holes | **Permanently blocked** at system and browser policy levels |
| **Academic YouTube Lectures** | Unrestricted recommended videos | **Forced Restricted Safety Mode** (No adult/distracting videos) |
| **Essential Study Groups (FB/Reddit)** | Addictive endless scrolling feeds | **Locked by default**; unlocked for **14 minutes** only upon solving pen-and-paper math |
| **Crash Protection** | Vulnerable if background script dies | **Intelligent systemd Guardian** auto-repairs blocks and recovers timers |
| **Online Lectures & Classes** | N/A | One-click **Online Class Mode** (`Super + Alt + B`) for full color lectures |

---

## 🏛️ System Architecture & Features

```
┌────────────────────────────────────────────────────────────────────────┐
│                        UBUNTU-FOR-STUDY ENGINE                         │
└────────────────────────────────────────────────────────────────────────┘
          │                                           │
          ▼                                           ▼
┌───────────────────────────┐               ┌───────────────────────────┐
│  3-TIER NETWORK SINKHOLE  │               │   HARDWARE VISUAL ENGINE  │
│ ───────────────────────── │               │ ───────────────────────── │
│ • 150k+ Adult Domains     │               │ • 24/7 Clutter Grayscale  │
│ • Cloudflare Family DNS   │               │ • Sleep/Wake Hook Auto-Fix│
│ • Immutable /etc/hosts    │               │ • Screen Unlock Listener  │
│ • Browser Policies        │               │ • Super+Alt+B Lecture Mode│
└───────────────────────────┘               └───────────────────────────┘
          │                                           │
          ▼                                           ▼
┌───────────────────────────┐               ┌───────────────────────────┐
│   INTENTIONAL ACCESS GATE │               │   SELF-HEALING GUARDIAN   │
│ ───────────────────────── │               │ ───────────────────────── │
│ • HSC Differentiation Math│               │ • Persistent Timers       │
│ • 3 Strikes = 30m Lockout │               │ • Auto-Restore on Reboot  │
│ • 20 Islamic Conscience Qs│               │ • /etc/hosts Watchdog     │
│ • Strict 14-Minute Window │               │ • Systemd Auto-Restart    │
└───────────────────────────┘               └───────────────────────────┘
```

---

### 1. 🛡️ 4-Tier Network & Adult Content Sinkhole

1. **Kernel-Level Immutable Sinkhole (`/etc/hosts`):**
   - Merges curated 150,000+ domain adult & social sinkholes (StevenBlack pornography-social filter).
   - Explicit sinkholes for regional adult networks (Bengali choti blogs, MMS leaks, Desi adult hubs like `mmsgram.com`, `banglachotikahinii.com`, `desimms.com`, etc.).
   - Core compulsive platforms (`instagram.com`, `tiktok.com`, `x.com`, `threads.net`, `snapchat.com`, `twitch.tv`) are routed to `0.0.0.0`.
   - The file is protected with the ext4 immutable attribute (`chattr +i`).
   - `web.whatsapp.com` is explicitly whitelisted for essential family & student messaging.

2. **Encrypted Family DNS Enforcement (`systemd-resolved`):**
   - Directs all system DNS through Cloudflare Family DNS (`1.1.1.3` / `1.0.0.3`), AdGuard Family (`94.140.14.15`), and CleanBrowsing Adult (`185.228.168.168`).
   - DoH/DoT bypass canaries (`use-application-dns.net`, `dns.google`, `cloudflare-dns.com`) are sinkholed to prevent browser evasion.

3. **Unified Enterprise Browser Hardening (Chrome, Brave, Chromium, Firefox):**
   - Enforces `URLBlocklist` and `URLAllowlist` machine-wide across all browsers:
     - **Complete Adult & Explicit Eradication:** Wildcards covering all adult tubes, regional leak blogs, webcams, OnlyFans leaks (`*://*porn*/*`, `*://*xxx*/*`, `*://*choti*/*`, `*://*mmsgram*/*`, `*://*desimms*/*`, `*://*onlyfans*/*`, etc.).
     - **YouTube Shorts Eradication:** `*://*.youtube.com/shorts/*` blocked at the network engine layer.
     - **Facebook Restricted to 4 Groups:** `*://*.facebook.com/*` blocked except the 4 authorized academic groups and group video streams.
     - **Permanent Blocks:** Instagram, Threads, TikTok, Twitter/X, Snapchat, Twitch.
   - Private / Incognito browsing is strictly disabled.
   - Background browser persistence disabled (`BackgroundModeEnabled: false`) so processes cannot linger silently.
   - Search suggestions disabled to prevent clickbait prompts.
   - New tab redirected to `about:blank`.

---

### 2. 🌐 Guardian Engine: Unified Protection Across All Browsers

Whether you launch **Google Chrome**, **Brave**, or **StudyBrowser**, the **Guardian Engine** is automatically loaded to guarantee zero bypass:

#### 🚫 YouTube: Pure Academic Mode
* **100% Shorts Eradication:** Drops all navigation requests to `/shorts/*` before a single frame can load, instantly bouncing back to `youtube.com/`.
* **Blank Homepage:** When you open YouTube, the recommended video feed is completely hidden. You see only a clean search bar. You search for what you need to study, and watch your lecture.
* **Hidden Side Recommendations:** While watching a class video, the entire right sidebar of recommended videos and end-screen suggestions is completely removed.
* **Full-Length Lectures Allowed:** Watch normal educational lectures (`/watch?v=...`) with clean video streaming and zero algorithmic rabbit holes.

#### 🔒 Strictly 4 Authorized Facebook Groups Only
* **Access Restricted Exclusively To:**
  1. 🧬 **FAB Zoology 27** (`facebook.com/groups/fabzoology27/`)
  2. 🌿 **FAB Botany 27** (`facebook.com/groups/fabbotany27/`)
  3. 📐 **Academic Study Group** (`facebook.com/groups/1612120089807832/`)
  4. 🧪 **Engineering Chemistry (HSC 26)** (`facebook.com/groups/saikatvaisengineeringchemistryhsc26/`)
* **Personal Feeds & Reels Annihilated:**
  - Direct attempts to open the News Feed (`facebook.com/`), Reels (`facebook.com/reel/`), or Watch (`facebook.com/watch/`) are intercepted and blocked with a warning screen.
  - History API (`pushState` / `replaceState`) is hooked: clicking any external link inside a group is cancelled in the capture phase.
  - Top navigation icons (Home, Video, Marketplace, Gaming) are completely stripped from the page DOM.
* **Full Group Video Playback:** Videos, live streams, and lecture recordings posted inside the 4 authorized groups play with HD streaming, pause/play, speed controls, and fullscreen.

---

### 3. 🧮 Controlled 14-Minute Study Access

Need to check an urgent notice in an HSC Facebook group or search an academic thread on Reddit? You cannot simply open them. You must earn your access:

#### 📘 Facebook Study Gate (`study-fb` / Desktop Shortcut)
1. Prompts you with an authentic **HSC-level Mathematics Problem** (Differentiation & Algebra):
   - Polynomial derivative evaluation: $f'(x_0)$ for cubics
   - Tangent slope: $\left.\frac{dy}{dx}\right|_{x=x_0}$
   - Stationary / Critical points: $\frac{dy}{dx} = 0$
   - Second derivatives: $\frac{d^2y}{dx^2}$
   - Quadratic root identities: $\alpha^2 + \beta^2 = (\alpha+\beta)^2 - 2\alpha\beta$
   - Vector scalar dot products: $\vec{u} \cdot \vec{v}$
   - $2 \times 2$ Matrix determinants: $ad - bc$
   *(Strictly calibrated for 2–3 minutes of pencil-and-paper calculation; zero admission-level tricks, zero integrations).*
2. **3-Strike / 30-Minute Lockout Rule:**
   - You get **3 attempts**. If you submit 3 incorrect answers, the system initiates an **immediate 30-minute lockdown**.
   - During the lockout, no math challenges or access are permitted under any circumstances.
3. Upon solving the problem correctly, Facebook is temporarily unlocked for **exactly 14 minutes**, with an active desktop countdown reminder. After 14 minutes, it locks automatically.

#### 🔴 Reddit Conscience Gate (`study-reddit` / Desktop Shortcut)
1. Solve the HSC Mathematics problem.
2. If correct, you are confronted with **5 Randomized Islamic Conscience Questions** drawn dynamically from an authentic library of 20 Quranic verses and Hadiths:
   - **Al-Muraqabah (The All-Seeing):** *“Does he not know that Allah sees?”* (Surah Al-'Alaq 96:14)
   - **The Stealthy Glance:** *“Allah knows the deception of the eyes and whatever the hearts conceal.”* (Surah Ghafir 40:19)
   - **Testimony of the Body:** *“On this Day, We will seal their mouths, their hands will speak to Us, and their feet will testify.”* (Surah Ya-Sin 36:65)
   - **Sins in Seclusion:** The stern warning of the Prophet (ﷺ) regarding good deeds turned into scattered dust due to secret sins (Sunan Ibn Majah #4245).
   - **The Sacred Trust of Youth & HSC Exams:** Account of youth on the Day of Judgment (Sunan At-Tirmidhi).
   - **Sudden Arrival of Death:** *“My Lord, send me back that I might do good!”* (Surah Al-Mu'minun 23:99).
3. You must reflect and consciously confirm all 5 questions by typing `"yes"`. Any hesitation or refusal cancels access immediately.
4. If passed, Reddit is unlocked for **14 minutes**.

---

### 4. 🤖 Intelligent Self-Healing & Crash Recovery

Distraction blockers that fail after a system crash or reboot are useless. Ubuntu-For-Study is designed to be **self-healing**:

* **Systemd Guardian Service (`study-guardian.service`):**
  - Runs in the background with `Restart=always` and `RestartSec=5`.
  - Starts automatically on boot (`WantedBy=multi-user.target`).
* **Crash-Proof Timers:** Unlock timestamps are stored persistently in `/etc/study-timer`. If the PC powers off, sleeps, or reboots during an unlocked window, the guardian checks elapsed time on reboot:
  - If 14 minutes have passed: immediately cleans up timestamps and re-locks `/etc/hosts`.
  - If time remains: accurately maintains the countdown without resetting or giving unlimited time.
* **Hosts Integrity Self-Repair:** If `/etc/hosts` is modified, deleted, or missing blocks, the guardian instantly restores it from `/etc/hosts.master` and re-applies `chattr +i`.
* **Sleep & Unlock Visual Auto-Recovery:**
  - Suspend wake hook: `/lib/systemd/system-sleep/study-resume-grayscale.sh` re-applies the Clutter shader 1.5s after wake.
  - Screen unlock listener: `study-screen-listener.service` catches GNOME ScreenSaver DBus signals and re-enforces grayscale within 500ms of unlocking.

---

### 5. 🖥️ Hardware Grayscale & Dopamine Detox

* **24/7 Grayscale Mode:** Runs via GPU desaturation (`gnome-bedtime-mode`). Removes color-based dopamine triggers from social media, thumbnails, and ads.
* **Online Class Mode:** Attending a lecture where color is essential for chemistry diagrams or biology graphs?
  - Click the **Online Class Mode** icon on your Desktop, or
  - Press the global keyboard shortcut: `Super + Alt + B`.
  - Press again when class finishes to instantly re-enter Grayscale Study Mode.
* **Minimalist Desktop Environment:**
  - Window animations completely disabled for zero motion distractions.
  - System event sounds and alert bells muted.
  - GNOME Dock auto-hiding automatically.
  - 4000K warm night light active 24/7 to reduce eye fatigue during late-night study sessions.
  - Solid dark gray wallpaper (`#1e1e1e`) with clean, distraction-free desktop shortcuts.

---

## ⌨️ Command Line Reference

All tools are installed system-wide in `/usr/local/bin` and can be run from any terminal:

| Command | Action |
| :--- | :--- |
| `study-browser` | Launch **StudyBrowser** (Zero YouTube Shorts, 4 Facebook groups only) |
| `study-fb` | Launch Facebook HSC differentiation challenge (14-min unlock) |
| `study-reddit` | Launch Reddit challenge (HSC math + 5 Islamic reflection gates) |
| `toggle-bw` | Toggle between Full Color (Online Class Mode) and Grayscale |
| `toggle-bw --force-on` | Force Grayscale mode on immediately |
| `focus [minutes]` | Monotasking focus timer with automatic Do Not Disturb (e.g. `focus 25`) |
| `sudo study-timer-daemon status <service>` | Check remaining time on active unlock |
| `sudo study-timer-daemon lock <service>` | Manually lock access early when finished |
| `sudo study-timer-daemon sync` | Force immediate synchronization of hosts, policies, and DNS |

---

## 📂 Repository Structure

```text
Ubuntu-For-Study/
├── .gitignore                         # Protects against committing secrets or tokens
├── README.md                          # Complete system guide & documentation
├── install.sh                         # 1-command installer (self-bootstrap & self-healing)
├── uninstall.sh                       # 1-click uninstaller & complete default restorer
├── desktop/
│   ├── study-browser.desktop          # Desktop launcher for Super Strict StudyBrowser
│   ├── online-class-mode.desktop      # Desktop button for Super+Alt+B lecture color toggle
│   ├── study-fb.desktop               # Desktop launcher for Facebook HSC math gate
│   └── study-reddit.desktop           # Desktop launcher for Reddit math + conscience gate
├── study-browser-extension/           # Super Strict Browser Guardian Extension
│   ├── manifest.json                  # Extension manifest (MV3)
│   ├── background.js                  # Navigation interceptor & policy engine
│   ├── rules.json                     # Declarative network redirect rules
│   ├── content_youtube.js             # SPA Shorts killer & MutationObserver
│   ├── style_youtube.css              # DOM CSS purging all Shorts elements
│   ├── content_facebook.js            # 4-group enforcer & capture-phase link guard
│   ├── style_facebook.css             # DOM CSS stripping feeds, reels, and nav icons
│   ├── dashboard.html                 # Clean, dark academic study portal
│   ├── blocked_fb.html                # Unauthorized Facebook attempt warning
│   └── blocked_shorts.html            # Shorts eradication notice screen
└── scripts/
    ├── study-browser                  # Launcher for StudyBrowser application
    ├── hsc_math_engine.py             # Procedural HSC differentiation & algebra math generator
    ├── study_lockout.py               # 3-strike lockout & 30-minute penalty state manager
    ├── study-fb                       # Interactive CLI for Facebook study gate
    ├── study-reddit                   # Interactive CLI for Reddit math + Islamic conscience gate
    ├── study-timer-daemon.py          # Core daemon, hosts sync, and watchdog self-healing loop
    ├── study-screen-listener          # DBus daemon enforcing grayscale on screen unlock
    ├── study-resume-grayscale.sh      # Systemd sleep/wake hook restoring grayscale
    ├── toggle-bw                      # Clutter bedtime shader switcher
    └── focus                          # Terminal Pomodoro timer with GNOME Do Not Disturb
```

---

## 🔄 Uninstallation & Full System Restore

If you ever wish to revert your system back to standard Ubuntu defaults, the uninstaller restores all configurations:

```bash
git clone https://github.com/Shajidur-Rahman/Ubuntu-For-Study.git
cd Ubuntu-For-Study
sudo bash uninstall.sh
```

**The uninstaller cleanly:**
1. Restores your original `/etc/hosts` and removes immutable flags.
2. Removes custom DNS configurations and restarts `systemd-resolved`.
3. Deletes browser enterprise policies from Chrome, Brave, and Firefox.
4. Stops and removes the `study-guardian.service` watchdog.
5. Re-enables desktop animations, sounds, default wallpaper, and dock settings.
6. Removes desktop launchers and CLI binaries.

---

## 📜 License

Distributed under the **MIT License**.  
Engineered with ❤️ for students striving for discipline, academic excellence, and noble character.
