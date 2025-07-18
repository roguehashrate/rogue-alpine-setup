#!/bin/sh

# Ensure root
if [ "$(id -u)" -ne 0 ]; then
  echo "❌ Please run as root."
  exit 1
fi

# Ensure a non-root user exists
USER_NAME=$(getent passwd 1000 | cut -d: -f1)
if [ -z "$USER_NAME" ]; then
  echo "❌ No non-root user found (UID 1000). Create one before running this script."
  exit 1
fi

echo "[*] Installing networking and audio packages..."
apk add networkmanager networkmanager-wifi \
        network-manager-applet \
        wpa_supplicant \
        pipewire pipewire-alsa pipewire-pulse wireplumber \
        polkit polkit-gnome

# Remove iwd if installed
apk del iwd || true

echo "[*] Stopping conflicting services..."
rc-service networking stop || true
rc-service wpa_supplicant stop || true

rc-update del networking || true
rc-update del wpa_supplicant || true

echo "[*] Enabling dbus, udev, and networkmanager..."
rc-update add dbus
rc-update add udev
rc-update add networkmanager

rc-service dbus start
rc-service udev start
rc-service networkmanager restart

echo "[*] Adding user '$USER_NAME' to plugdev group for NetworkManager GUI access..."
adduser "$USER_NAME" plugdev

echo "[*] Configuring NetworkManager for wpa_supplicant backend..."
mkdir -p /etc/NetworkManager
cat <<EOF > /etc/NetworkManager/NetworkManager.conf
[main]
dhcp=internal
plugins=ifupdown,keyfile

[ifupdown]
managed=true

[device]
wifi.scan-rand-mac-address=yes
wifi.backend=wpa_supplicant
EOF

echo "[*] Allowing all users to manage network connections (disabling polkit requirement)..."
mkdir -p /etc/NetworkManager/conf.d
cat <<EOF > /etc/NetworkManager/conf.d/any-user.conf
[main]
auth-polkit=false
EOF

echo "[*] Resetting /etc/network/interfaces to only loopback..."
echo "auto lo" > /etc/network/interfaces
echo "iface lo inet loopback" >> /etc/network/interfaces

echo "[*] Restarting NetworkManager..."
rc-service networkmanager restart

echo
echo "[✓] NetworkManager is fully configured."
echo "    ✔ Wi-Fi and Ethernet manageable in GNOME"
echo "    ✔ No conflicts with legacy tools"
echo "    ✔ Audio via PipeWire is ready"
echo
echo "🔁 You should now reboot your system for full effect."

