#!/bin/sh

if [ "$(id -u)" -ne 0 ]; then
  echo "❌ Please run this script as root."
  exit 1
fi

echo "[*] Starting GNOME debloat process..."

# Define removable apps
apps_to_remove="
firefox
gnome-tour
gnome-maps
gnome-maps
gnome-music
gnome-contacts
gnome-calendar
gnome-weather
epiphany
totem
cheese
simple-scan
"

for pkg in $apps_to_remove; do
  if apk info -e "$pkg" > /dev/null 2>&1; then
    echo
    echo "🗑️  $pkg is installed. Remove it?"
    echo "1) Yes"
    echo "2) No"
    printf "Enter choice [1-2]: "
    read choice
    if [ "$choice" = "1" ]; then
      apk del "$pkg"
    else
      echo "[>] Skipping $pkg"
    fi
  fi
done

echo
echo "[✓] Debloat complete!"

