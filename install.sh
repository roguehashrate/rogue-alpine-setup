#!/bin/sh

# Ensure the script is run as root
if [ "$(id -u)" -ne 0 ]; then
  echo "❌ Please run this script as root."
  exit 1
fi

echo "[*] Ensuring 'community' repository is enabled..."
if ! grep -q "/community" /etc/apk/repositories; then
    release=$(awk -F. '{print $1 "." $2}' /etc/alpine-release)
    echo "http://dl-cdn.alpinelinux.org/alpine/v$release/community" >> /etc/apk/repositories
fi

echo "[*] Updating package index..."
apk update

echo "[*] Installing GNOME and core desktop environment..."
apk add gnome-shell gnome-terminal gdm \
        gnome-control-center gnome-settings-daemon \
        gnome-backgrounds gnome-disk-utility \
        gnome-keyring gnome-software \
        gvfs gvfs-afc gvfs-mtp gvfs-smb \
        udisks2 networkmanager network-manager-applet \
        xdg-desktop-portal-gtk flatpak \
        mesa mesa-dri-gallium

echo "[*] Enabling essential system services..."
rc-update add dbus
rc-update add udev
rc-update add NetworkManager
rc-update add gdm

echo "[*] Installing PipeWire for audio routing..."
apk add pipewire pipewire-alsa pipewire-pulse wireplumber

echo "[*] Installing Bluetooth support..."
apk add bluez bluez-alsa gnome-bluetooth
rc-update add bluetooth
rc-service bluetooth start

echo "[*] Setting up Flatpak and Flathub remote..."
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Web Browser
echo
echo "[*] Optional: Install Web Browser?"
echo "1) Firefox"
echo "2) Brave"
echo "3) None"
printf "Enter choice [1-3]: "
read opt
case $opt in
  1) flatpak install -y flathub org.mozilla.firefox ;;
  2) flatpak install -y flathub com.brave.Browser ;;
esac

# Text Editor
echo
echo "[*] Optional: Install Text Editor?"
echo "1) Vim"
echo "2) Neovim"
echo "3) Emacs"
echo "4) None"
printf "Enter choice [1-4]: "
read opt
case $opt in
  1) apk add vim ;;
  2) apk add neovim ;;
  3) apk add emacs ;;
esac

# Terminal Emulator
echo
echo "[*] Optional: Install Terminal Emulator?"
echo "1) Alacritty"
echo "2) Kitty"
echo "3) None"
printf "Enter choice [1-3]: "
read opt
case $opt in
  1) apk add alacritty ;;
  2) apk add kitty ;;
esac

# Image Tool
echo
echo "[*] Optional: Install Image Tool?"
echo "1) GIMP"
echo "2) Krita"
echo "3) None"
printf "Enter choice [1-3]: "
read opt
case $opt in
  1) flatpak install -y flathub org.gimp.GIMP ;;
  2) flatpak install -y flathub org.kde.krita ;;
esac

# OBS
echo
echo "[*] Optional: Install OBS Studio?"
echo "1) Yes"
echo "2) No"
printf "Enter choice [1-2]: "
read opt
case $opt in
  1) flatpak install -y flathub com.obsproject.Studio ;;
esac

echo
echo "[✓] Setup complete! Reboot the system to launch into GNOME with full desktop support."

