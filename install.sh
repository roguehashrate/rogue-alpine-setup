#!/bin/sh

# Ensure the script is run as root
if [ "$(id -u)" -ne 0 ]; then
  echo "❌ Please run this script as root."
  exit 1
fi

echo "[*] Updating package index..."
apk update

# Auto-run alpine-desktop gnome if GNOME is not installed
if ! command -v gnome-shell >/dev/null 2>&1; then
  echo "[*] GNOME not detected — installing via alpine-desktop..."
  setup-desktop gnome
else
  echo "[*] GNOME already installed — skipping alpine-desktop."
fi

echo "[*] Installing Flatpak and GNOME integration..."
apk add flatpak xdg-desktop-portal xdg-desktop-portal-gtk \
        gnome-software gnome-software-plugin-flatpak

mkdir -p /var/lib/flatpak

echo "[*] Adding Flathub remote..."
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo "[*] Installing PipeWire and Bluetooth support..."
apk add pipewire pipewire-alsa pipewire-pulse wireplumber \
        bluez bluez-alsa gnome-bluetooth

rc-update add bluetooth
rc-service bluetooth start

echo
echo "[*] Optional: Install Web Browser?"
echo "1) Firefox (Flatpak)"
echo "2) Brave (Flatpak)"
echo "3) None"
printf "Enter choice [1-3]: "
read opt
case "$opt" in
  1) flatpak install -y flathub org.mozilla.firefox ;;
  2) flatpak install -y flathub com.brave.Browser ;;
esac

echo
echo "[*] Optional: Install Text Editor?"
echo "1) Vim"
echo "2) Neovim"
echo "3) Emacs"
echo "4) None"
printf "Enter choice [1-4]: "
read opt
case "$opt" in
  1) apk add vim ;;
  2) apk add neovim ;;
  3) apk add emacs ;;
esac

echo
echo "[*] Optional: Install Terminal Emulator?"
echo "1) Alacritty"
echo "2) Kitty"
echo "3) None"
printf "Enter choice [1-3]: "
read opt
case "$opt" in
  1) apk add alacritty ;;
  2) apk add kitty ;;
esac

echo
echo "[*] Optional: Install Image Tool?"
echo "1) GIMP"
echo "2) Krita"
echo "3) None"
printf "Enter choice [1-3]: "
read opt
case "$opt" in
  1) flatpak install -y flathub org.gimp.GIMP ;;
  2) flatpak install -y flathub org.kde.krita ;;
esac

echo
echo "[*] Optional: Install OBS Studio?"
echo "1) Yes"
echo "2) No"
printf "Enter choice [1-2]: "
read opt
case "$opt" in
  1) flatpak install -y flathub com.obsproject.Studio ;;
esac

echo
echo "[✓] Setup complete! Reboot to your GNOME environment."

