#!/bin/sh

# Ensure the script is run as root
if [ "$(id -u)" -ne 0 ]; then
  echo "❌ Please run this script as root."
  exit 1
fi

echo "[*] Installing NetworkManager, WPA support, Bluetooth, PipeWire, and Polkit..."
apk add networkmanager wpa_supplicant \
        bluez bluez-alsa gnome-bluetooth \
        pipewire pipewire-alsa pipewire-pulse wireplumber \
        polkit polkit-gnome

# Remove iwd to prevent conflicts with wpa_supplicant
apk del iwd || true

echo "[*] Enabling essential services..."
rc-update add dbus
rc-update add udev
rc-update add bluetooth
rc-update add networkmanager
rc-update add wpa_supplicant

# Start services now
rc-service dbus start
rc-service udev start
rc-service bluetooth start
rc-service networkmanager start
rc-service wpa_supplicant start

# Ensure GDM and GNOME will start if not already done
rc-update add gdm
rc-service gdm restart

echo
echo "[✓] Networking stack installed and running."
echo "    ✔ Wi-Fi via NetworkManager (GNOME control center)"
echo "    ✔ Bluetooth via GNOME Bluetooth"
echo "    ✔ PipeWire for audio"
echo "    ✔ Polkit agent for GNOME permissions"

echo
echo "🔁 Please reboot to fully apply these changes."

