
---

# 🚀 Alpine GNOME Setup Script

This is a post-install script that turns a fresh Alpine Linux installation into a complete GNOME desktop system — including Flatpak, audio (PipeWire), Bluetooth, and Wi-Fi support — with optional software installs like browsers, text editors, and creative tools.

---

## 📋 Before You Begin

Before running this script, you **must enable the `community` repository** and install `git`:

### 1. Enable the `community` repository

Some packages are only in the `community` repo.

1. Open the APK repository list:
   ```sh
   vi /etc/apk/repositories
   ```

2. Uncomment the `community` line (remove `#`), for example:
   ```
   # https://dl-cdn.alpinelinux.org/alpine/v3.22/community
   ```

3. Save and exit, then update the index:
   ```sh
   apk update
   ```

### 2. Install `git`

```sh
apk add git
```

---

## 🔧 What This Script Does

- Installs the full GNOME desktop via `setup-desktop gnome`
- Removes default GNOME browsers (Firefox and Epiphany)
- Installs Flatpak and Flathub
- Adds PipeWire and WirePlumber for audio
- Enables Bluetooth and Wi-Fi (via `wpa_supplicant`)
- Starts all essential services (dbus, gdm, networkmanager, etc.)
- Offers optional installs: browser, editor, terminal, image tools, OBS Studio

---

## 💡 How to Use

1. **Install Alpine normally using `setup-alpine`**
2. **Reboot and log in as `root`**
3. **Fetch and run the script**:

```sh
git clone https://github.com/roguehashrate/rogue-alpine-setup.git
cd rogue-alpine-setup
chmod +x install.sh
./install.sh
```

4. Follow the prompts
5. When done, reboot:
```sh
reboot
```

---

## 🧪 Features Verified to Work

- GNOME session (Wayland) with login manager (GDM)
- Flatpak support with Flathub remote
- PipeWire audio visible in GNOME sound menu
- Bluetooth management from GNOME settings
- Wi-Fi using `wpa_supplicant` and NetworkManager

---

## 📦 Optional Software Offered

- **Web Browsers:** Firefox (Flatpak), Brave (Flatpak)
- **Text Editors:** Vim, Neovim, Emacs
- **Terminal Emulators:** Alacritty, Kitty
- **Image Tools:** GIMP, Krita
- **Streaming:** OBS Studio (Flatpak)

---

## ⚠️ Notes

- Flatpaks are installed system-wide as root (you can modify the script to use `--user` if preferred)
- You must manually enable the `community` repo before starting
- Requires a working network connection (Ethernet or pre-configured Wi-Fi)

---

## 📜 License

MIT — use, fork, and modify freely. PRs welcome!
```
