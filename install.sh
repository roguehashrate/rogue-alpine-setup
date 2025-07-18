#!/bin/sh

# Ensure the script is run as root
if [ "$(id -u)" -ne 0 ]; then
  echo "❌ Please run this script as root."
  exit 1
fi

echo "[*] Updating package index..."
apk update

# Enable community repo if not already
if ! grep -q "/community" /etc/apk/repositories; then
  release=$(cut -d. -f1,2 /etc/alpine-release)
  echo "https://dl-cdn.alpinelinux.org/alpine/v$release/community" >> /etc/apk/repositories
  apk update
fi

# Auto-run alpine-desktop gnome if GNOME is not installed
if ! command -v gnome-shell >/dev/null 2>&1; then
  echo "[*] GNOME not detected — installing via alpine-desktop..."
  setup-desktop gnome
else
  echo "[*] GNOME already installed — skipping alpine-desktop."
fi

echo "[*] Removing default GNOME browsers..."
apk del -q firefox epiphany || echo "[!] Some packages may not have been installed — skipping."

echo "[*] Installing Flatpak and GNOME integration..."
apk add flatpak xdg-desktop-portal xdg-desktop-portal-gtk \
        gnome-software gnome-software-plugin-flatpak

mkdir -p /var/lib/flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo "[*] Installing PipeWire, Bluetooth, and Network tools..."
apk add pipewire pipewire-alsa pipewire-pulse wireplumber \
        bluez bluez-alsa gnome-bluetooth \
        networkmanager wpa_supplicant

echo "[*] Enabling system services..."
rc-update add dbus
rc-update add udev
rc-update add bluetooth
rc-update add networkmanager
rc-update add wpa_supplicant
rc-update add gdm

# Optional Web Browser
echo
echo "[*] Optional: Install Web Browser?"
echo "1) Firefox (Flatpak)"
echo "2) Brave (Flatpak)"
echo "3) None"
printf "Enter choice [1-3]: "
read opt_browser
case "$opt_browser" in
  1) flatpak install -y flathub org.mozilla.firefox ;;
  2) flatpak install -y flathub com.brave.Browser ;;
esac

# Optional Text Editor
echo
echo "[*] Optional: Install Text Editor?"
echo "1) Vim"
echo "2) Neovim"
echo "3) Emacs"
echo "4) None"
printf "Enter choice [1-4]: "
read opt_editor
case "$opt_editor" in
  1) apk add vim ;;
  2) apk add neovim ;;
  3) apk add emacs ;;
esac

# Optional Terminal Emulator
echo
echo "[*] Optional: Install Terminal Emulator?"
echo "1) Alacritty"
echo "2) Kitty"
echo "3) None"
printf "Enter choice [1-3]: "
read opt_term
case "$opt_term" in
  1) apk add alacritty ;;
  2) apk add kitty ;;
esac

# Optional Image Tool
echo
echo "[*] Optional: Install Image Tool?"
echo "1) GIMP"
echo "2) Krita"
echo "3) None"
printf "Enter choice [1-3]: "
read opt_image
case "$opt_image" in
  1) flatpak install -y flathub org.gimp.GIMP ;;
  2) flatpak install -y flathub org.kde.krita ;;
esac

# Optional OBS
echo
echo "[*] Optional: Install OBS Studio?"
echo "1) Yes"
echo "2) No"
printf "Enter choice [1-2]: "
read opt_obs
case "$opt_obs" in
  1) flatpak install -y flathub com.obsproject.Studio ;;
esac

echo
echo "[✓] Setup complete! Please reboot to start GNOME."

