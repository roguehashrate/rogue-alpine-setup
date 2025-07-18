#!/bin/sh

# Ensure the script is run as root
if [ "$(id -u)" -ne 0 ]; then
  echo "❌ Please run this script as root."
  exit 1
fi

echo "[*] Installing networking and audio packages..."
apk add networkmanager wpa_supplicant \
        pipewire pipewire-alsa pipewire-pulse wireplumber \
        polkit polkit-gnome

# Remove iwd to avoid conflicts
apk del iwd || true

echo "[*] Enabling required services..."
rc-update add dbus
rc-update add udev
rc-update add networkmanager
rc-update add wpa_supplicant

rc-service dbus start
rc-service udev start
rc-service networkmanager start
rc-service wpa_supplicant start

echo "[*] Fixing 'unmanaged' NetworkManager issue..."

# Reset /etc/network/interfaces to loopback only
echo "auto lo" > /etc/network/interfaces
echo "iface lo inet loopback" >> /etc/network/interfaces

# Tell NetworkManager to manage all interfaces
mkdir -p /etc/NetworkManager/conf.d
cat <<EOF > /etc/NetworkManager/conf.d/10-managed.conf
[main]
plugins=keyfile

[ifupdown]
managed=true
EOF

# Restart to apply config
rc-service networkmanager restart

echo
echo "[✓] NetworkManager is now managing your interfaces."
echo "    ✔ Wi-Fi should be fully interactive in GNOME UI"
echo "    ✔ Audio via PipeWire is active"
echo
echo "🔁 Reboot the system to ensure all changes take full effect."
