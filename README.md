
<p align="center">
  <img src="/assets/logo.png" alt="Logo" width="300"/>
</p>

A post-install script that transforms a fresh Alpine Linux system into a modern GNOME desktop — complete with audio, Bluetooth, Flatpak, and GUI-based network management.

> ⚠️ This is intended to be run **after completing `setup-alpine`** on a new Alpine installation.

> 🔒 **You must run all scripts as root.**

---

## ✅ Features

- Full **GNOME Desktop** via `setup-desktop`
- **PipeWire** audio routing
- **Bluetooth** support
- **Flatpak** + Flathub integration
- **NetworkManager** with full GNOME GUI integration
- Optional GUI apps (prompted during install)
- Optional debloat script to remove unwanted default software

(I recommend removing the default firefox and installing the flatpak if you ever need DRM support in your browser)

---

## 📦 Requirements

Before running the scripts:

1. **Enable the `community` repository**

   ```sh
   vi /etc/apk/repositories
   ```
   Remove the `#` from the line ending in `/community`.

2. **Install `git`**

   ```sh
   apk add git
   ```

---

## 🚀 Installation

### 1. Clone the repository

```sh
git clone https://github.com/roguehashrate/rogue-alpine-setup
cd rogue-alpine-setup
```

### 2. Make the scripts executable

```sh
chmod +x install.sh networking.sh
```

### 3. Run the main install script

```sh
./install.sh
```

This will:
- Install GNOME
- Set up audio, Bluetooth, Flatpak
- Remove default GNOME browsers
- Prompt for installing common apps

### 4. Run the networking script

To ensure GNOME can manage Wi-Fi and network devices:

```sh
./networking.sh
```

This configures NetworkManager for proper user-level interaction and disables conflicting services.

---

## 🧩 Optional Apps (Prompted During Install)

You’ll be asked whether to install:

- Web Browsers: Firefox (Flatpak), Brave (Flatpak)
- Text Editors: Vim, Neovim, Emacs
- Terminal Emulators: Alacritty, Kitty
- Image Editors: GIMP(Flatpak), Krita(Flatpak)
- OBS Studio (Flatpak)

---

## 📄 License

MIT License — see `LICENSE` file.
