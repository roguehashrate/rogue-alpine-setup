#!/bin/sh

# Ensure root
if [ "$(id -u)" -ne 0 ]; then
  echo "❌ Please run as root."
  exit 1
fi

echo "[*] Installing networking tools..."

# Install NetworkManager and WPA supplicant
apk add networkmanager wpa_supplicant

# Remove iwd if present (can conflict with wpa_supplicant)
apk del iwd || true

# Enable services
echo "[*] Enabling services..."
rc-update add dbus
rc-update add udev
rc-update add networkmanager
rc-update add wpa_supplicant

# Start services (optional — they’ll start on reboot anyway)
echo "[*] Starting services..."
rc-service dbus start
rc-service udev start
rc-service networkmanager start
rc-service wpa_supplicant start

echo
echo "[✓] Network setup complete. Reboot or connect using GNOME Settings."

