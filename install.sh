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

