#!/bin/bash
echo "🚀 Starting Arch final installation"

sudo pacman -S --needed git base-devel --noconfirm
git clone https://aur.archlinux.org/yay.git /tmp/yay
cd /tmp/yay
makepkg -si
cd ~
rm -rf /tmp/yay


# Ask user if he needs to fix grub not showing up or not finding windows dual boot 
read -p "Did you need to fix dual boot not finding windows arch? (y/N): " fix_grub
fix_grub=${fix_grub,,}  # to lowercase
if [[ "$fix_grub" == "y" || "$fix_grub" == "yes" ]]; then
    sudo pacman -S grub efibootmgr os-prober --noconfirm
    sudo grub-install --target=x86_64-efi --efi-directory=/boot --recheck
    # Activer os-prober dans GRUB
    if grep -q "^#GRUB_DISABLE_OS_PROBER=false" /etc/default/grub; then
        sudo sed -i 's/^#GRUB_DISABLE_OS_PROBER=false/GRUB_DISABLE_OS_PROBER=false/' /etc/default/grub
    elif ! grep -q "^GRUB_DISABLE_OS_PROBER=false" /etc/default/grub; then
        echo "GRUB_DISABLE_OS_PROBER=false" | sudo tee -a /etc/default/grub
    fi

    sudo grub-mkconfig -o /boot/grub/grub.cfg

    sudo os-prober


fi

# Ask user if multilib and extra repositories are enabled in /etc/pacman.conf
read -p "Did you enable [multilib] and [extra] repos in /etc/pacman.conf? (y/N): " enable_extra_repo
enable_extra_repo=${enable_extra_repo,,}  # to lowercase
if [[ "$enable_extra_repo" == "n" || "$enable_extra_repo" == "no" ]]; then
    echo "Opening /etc/pacman.conf for editing..."
    sudo nano /etc/pacman.conf
    echo "👉 Make sure you uncomment these lines:"
    echo "    [extra]"
    echo "    Include = /etc/pacman.d/mirrorlist"
    echo ""
    echo "    [multilib]"
    echo "    Include = /etc/pacman.d/mirrorlist"
    echo ""
    echo "After editing, press CTRL+O, ENTER, then CTRL+X to save and exit nano."
    read -p "Press Enter when you're done..."
    sudo pacman -Syu
    echo "✅ Repositories updated!"
fi


# Update system and install official packages
sudo pacman -Syu --noconfirm \
    steam layer-shell-qt5 qt6-wayland docker thunar nemo gedit showtime \
    linux-firmware mesa unzip ffmpeg vulkan-icd-loader vulkan-tools \
    nvidia-utils nvidia-settings qt6-svg qt6-virtualkeyboard qt6-multimedia-ffmpeg \
    fish tumbler ffmpegthumbnailer


# Install AUR packages
yay -Syu --noconfirm \
    ttf-twemoji-color beeper-v4-bin visual-studio-code-bin teams-for-linux deezer \
    atlauncher-bin noto-fonts noto-fonts-cjk noto-fonts-emoji qimgv-git
systemctl enable --now tumblerd
# Configure fontconfig for emojis and flags
mkdir -p ~/.config/fontconfig/conf.d/
cat > ~/.config/fontconfig/conf.d/01-emoji.conf <<'EOF'
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
  <alias>
    <family>sans-serif</family>
    <prefer>
      <family>Twemoji Color Emoji</family>
      <family>Noto Color Emoji</family>
    </prefer>
  </alias>
  <alias>
    <family>serif</family>
    <prefer>
      <family>Twemoji Color Emoji</family>
      <family>Noto Color Emoji</family>
    </prefer>
  </alias>
  <alias>
    <family>monospace</family>
    <prefer>
      <family>Twemoji Color Emoji</family>
      <family>Noto Color Emoji</family>
    </prefer>
  </alias>
</fontconfig>
EOF

# Rebuild font cache
fc-cache -fv

# Git config (optional)
git config --global user.name "Urectified"
git config --global user.email "nathanael.michau@epitech.eu"

# Install SDDM Astronaut themes
read -p "Do you want to install SDDM Astronaut themes? (y/N): " install_sddm
install_sddm=${install_sddm,,}
if [[ "$install_sddm" == "y" || "$install_sddm" == "yes" ]]; then
    sudo pacman -S sddm sddm-kcm --noconfirm
    cd /home/$USER
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/HANTALE/sddm-astronaut-random-theme/master/setup.sh)"
    echo "Done, BUT if you are using nvidia gpu PLS read this patch : https://github.com/Keyitdev/sddm-astronaut-theme/issues/64"
fi

# Install Elegant GRUB theme
read -p "Do you want to install Elegant GRUB theme? (y/N): " install_grub
install_grub=${install_grub,,}
if [[ "$install_grub" == "y" || "$install_grub" == "yes" ]]; then
    cd /home/$USER
    git clone https://github.com/vinceliuice/Elegant-grub2-themes.git
    cd Elegant-grub2-themes
    chmod +x install.sh
    sudo ./install.sh
fi

# Install Lutris with all dependencies
read -p "Do you want to install Lutris and all its dependencies? (y/N): " install_lutris
install_lutris=${install_lutris,,}
if [[ "$install_lutris" == "y" || "$install_lutris" == "yes" ]]; then
    sudo pacman -S --noconfirm \
        nvidia-utils lib32-nvidia-utils vulkan-tools lutris wine wine-gecko \
        wine-mono winetricks lib32-gnutls lib32-libldap lib32-mpg123 lib32-openal \
        lib32-v4l-utils lib32-libpulse lib32-alsa-plugins lib32-libxcomposite \
        lib32-libxinerama lib32-ncurses lib32-libxml2 lib32-freetype2 lib32-libpng \
        lib32-sdl2
    echo "Pls Follow this to install games without any issue: 👉 https://discord.com/channels/512538904872747018/538903130704838656/1386411255262216232"
fi

# Final instructions
echo edit bluetooth to use high quality
CONFIG_bluetooth="/home/$USER/.config/pipewire/media-session.d/with-a2dp-only.conf"
mkdir -p "$CONFIG_bluetooth"
echo "bluez5.codecs = [ aac ldac aptx aptx_hd sbc ]" >> "$CONFIG_bluetooth"
echo "bluez5.roles = [ a2dp_sink ]" >> "$CONFIG_bluetooth"

echo "⚙️  Please add !debug in /etc/makepkg.conf:"
echo "   OPTIONS=(strip docs !libtool !staticlibs emptydirs zipman purge !debug lto)"
echo ""
echo "🎨 For SDDM patch : https://github.com/Keyitdev/sddm-astronaut-theme/issues/64"
echo ""
echo "✅ Finished! If you do not have hyprland rice, check out the best one: https://github.com/caelestia-dots/caelestia and https://github.com/HyDE-Project/HyDE"
