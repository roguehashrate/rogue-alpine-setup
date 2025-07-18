#!/bin/sh

# Ensure the script is run as root
if [ "$(id -u)" -ne 0 ]; then
  echo "❌ Please run this script as root."
  exit 1
fi

echo "[*] Updating package index..."
apk update

echo "[*] Installing GNOME and core desktop..."
apk add gnome gnome-shell gnome-terminal gdm \
        xdg-desktop-portal xdg-desktop-portal-gtk \
        networkmanager network-manager-applet \
        gnome-control-center gnome-software \
        gvfs gvfs-afc gvfs-mtp gvfs-smb \
        udisks2 flatpak

echo "[*] Enabling essential services..."
rc-update add dbus
rc-update add udev
rc-update add NetworkManager
rc-update add gdm

echo "[*] Installing PipeWire audio and Bluetooth support..."
apk add pipewire pipewire-alsa pipewire-pulse pipewire-jack \
        wireplumber pulseaudio-ctl \
        bluez bluez-deprecated bluez-alsa pulseaudio-utils \
        gnome-bluetooth gnome-bluetooth-3.0 gnome-bluetooth-libs

echo "[*] Enabling Bluetooth service..."
rc-update add bluetooth
rc-service bluetooth start

echo "[*] Setting up Flatpak + Flathub..."
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo "[*] Optional: Install Browser?"
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

echo "[*] Optional: Install Image Manipulation Tool?"
select opt in "Gimp" "Krita" "None"; do
    case $opt in
        Gimp)
            flatpak install -y org.gimp.GIMP
            break
            ;;
        Krita)
            flatpak install -y org.kde.krita
            break
            ;;
        None)
            break
            ;;
    esac

echo "[*] Optional: Install OBS?"
select opt in "OBS" "None"; do
    case $opt in
        OBS)
            flatpak install -y com.obsproject.Studio
            break
            ;;
        None)
            break
            ;;
    esac
done

echo "[✓] All done! You can now reboot to start your graphical environment."
