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

echo "[*] Optional: Install Web Browser?"
select opt in "Firefox" "Brave" "None"; do
    case $opt in
        Firefox)
            flatpak install -y flathub org.mozilla.firefox
            break
            ;;
        Brave)
            flatpak install -y flathub com.brave.Browser
            break
            ;;
        None)
            break
            ;;
    esac
done

echo "[*] Optional: Install Text Editor?"
select opt in "Vim" "Neovim" "Emacs" "None"; do
    case $opt in
        Vim)
            apk add vim
            break
            ;;
        Neovim)
            apk add neovim
            break
            ;;
        Emacs)
            apk add emacs
            break
            ;;
        None)
            break
            ;;
    esac
done

echo "[*] Optional: Install Terminal Emulator?"
select opt in "Alacritty" "Kitty" "None"; do
    case $opt in
        Alacritty)
            apk add alacritty
            break
            ;;
        Kitty)
            apk add kitty
            break
            ;;
        None)
            break
            ;;
    esac
done

echo "[*] Optional: Install Image Tool?"
select opt in "Gimp" "Krita" "None"; do
    case $opt in
        Gimp)
            flatpak install -y flathub org.gimp.GIMP
            break
            ;;
        Krita)
            flatpak install -y flathub org.kde.krita
            break
            ;;
        None)
            break
            ;;
    esac
done

echo "[*] Optional: Install OBS?"
select opt in "OBS" "None"; do
    case $opt in
        OBS)
            flatpak install -y flathub com.obsproject.Studio
            break
            ;;
        None)
            break
            ;;
    esac
done

echo "[✓] Setup complete! Reboot the system to launch into GNOME with full audio, Bluetooth, networking, and Flatpak support."

