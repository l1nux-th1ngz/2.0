#!/bin/bash

echo "Welcome!" && sleep 2

echo "Updating system and adding necessary repositories to avoid potential issues..."
sudo apt-get update -y && sudo apt-get upgrade -y
sudo apt-get install -y curl wget git

echo "###########################################################################"
echo "Preparing to install packages and set up your environment."
echo "###########################################################################"

# Install essential packages
sudo apt-get install -y build-essential wget git meson cmake pkgconf libev-dev
sudo apt-get install -y xmonad nemo xdg-user-dirs xdg-user-dirs-gtk

# Make dirs
xdg-user-dirs-update
xdg-user-dirs-gtk-update

sudo apt-get install -y rofi feh xorg xinit xinput

# Create necessary directories
sudo mkdir -p /usr/local/share/fonts ~/.srcs

# Copy fonts and refresh font cache
sudo cp -r ./fonts/* /usr/local/share/fonts/
sudo fc-cache -f
clear

# Install additional packages
sudo apt-get install -y acpi alacritty kitty brightnessctl wmctrl playerctl dunst libghc-xmonad-contrib-doc jq xclip yad zenity xdotool maim xautolock i3lock imagemagick geany geany-plugins ffmpeg

# Download and set up betterlockscreen
wget https://raw.githubusercontent.com/mildmelon/betterlockscreen-ubuntu-installer/master/betterlockscreen.sh -O lock.sh
chmod +x lock.sh

# Install Greenclip
sudo wget https://github.com/erebe/greenclip/releases/download/v4.2/greenclip
chmod +x greenclip && sudo mv greenclip /usr/local/bin/

# Download and install Candy icons
wget https://github.com/EliverLara/candy-icons/archive/refs/heads/master.zip -O candy.zip
unzip candy.zip && sudo mv candy-icons-master /usr/share/icons/candy-icons

# Handle libasan symlink if necessary
if ! [ -f /usr/lib/libasan.so.6 ]; then
    sudo ln -s /usr/lib/libasan.so.8 /usr/lib/libasan.so.6
fi

# Setup Rofi configuration
mkdir -p ~/.config/rofi.old
if [ -d ~/.config/rofi ]; then
    echo "Backing up existing Rofi configs..."
    mv ~/.config/rofi/* ~/.config/rofi.old/
fi
echo "Installing Rofi configs..."
cp -r ./config/rofi/* ~/.config/rofi/

# Select screen resolution for Eww and set up Eww configuration
echo "Setting up Eww for 1920x1080 resolution..."
EWW_DIR='config/eww-1920'

mkdir -p ~/.config/eww.old
if [ -d ~/.config/eww ]; then
    echo "Backing up existing Eww configs..."
    mv ~/.config/eww/* ~/.config/eww.old/
fi
echo "Installing Eww configs..."
cp -r ./$EWW_DIR/* ~/.config/eww/

# Setup Picom configuration
if [ -f ~/.config/picom.conf ]; then
    echo "Backing up existing Picom config..."
    cp ~/.config/picom.conf ~/.config/picom.conf.old
fi
echo "Installing Picom config..."
cp ./config/picom.conf ~/.config/picom.conf

# Setup Alacritty configuration
if [ -f ~/.config/alacritty.yml ]; then
    echo "Backing up existing Alacritty config..."
    cp ~/.config/alacritty.yml ~/.config/alacritty.yml.old
fi
echo "Installing Alacritty config..."
cp ./config/alacritty.yml ~/.config/alacritty.yml

# Setup Dunst configuration
mkdir -p ~/.config/dunst.old
if [ -d ~/.config/dunst ]; then
    echo "Backing up existing Dunst configs..."
    mv ~/.config/dunst/* ~/.config/dunst.old/
fi
echo "Installing Dunst configs..."
cp -r ./config/dunst/* ~/.config/dunst/

# Install wallpapers
if [ -d ~/wallpapers ]; then
    echo "Adding wallpaper to ~/wallpapers..."
else
    echo "Installing wallpaper..."
    mkdir ~/wallpapers
fi
cp ./wallpapers/yosemite-lowpoly.jpg ~/wallpapers/

# Setup Tint2 configuration
mkdir -p ~/.config/tint2.old
if [ -d ~/.config/tint2 ]; then
    echo "Backing up existing Tint2 configs..."
    mv ~/.config/tint2/* ~/.config/tint2.old/
fi
echo "Installing Tint2 configs..."
cp -r ./config/tint2/* ~/.config/tint2/

# Setup XMonad configuration
mkdir -p ~/.xmonad.old
if [ -d ~/.xmonad ]; then
    echo "Backing up existing XMonad configs..."
    mv ~/.xmonad/* ~/.xmonad.old/
fi
echo "Installing XMonad configs..."
cp -r ./xmonad/* ~/.xmonad/

# Install custom scripts in ~/bin
mkdir -p ~/bin.old
if [ -d ~/bin ]; then
    echo "Backing up existing ~/bin scripts..."
    mv ~/bin/* ~/bin.old/
fi
echo "Installing custom scripts to ~/bin..."
cp -r ./bin/* ~/bin/

# Ensure ~/bin is in PATH
echo "Adding $HOME/bin to PATH..."
echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc

# Install LightDM and greeters
sudo apt-get install -y lightdm lightdm-gtk-greeter slick-greeter

# Set Slick Greeter as the default greeter
sudo bash -c 'echo "[Seat:*]" > /etc/lightdm/lightdm.conf'
sudo bash -c 'echo "greeter-session=slick-greeter" >> /etc/lightdm/lightdm.conf'

# Restart LightDM to apply changes
sudo systemctl restart lightdm

# Recompile XMonad
sleep 5
xmonad --recompile
