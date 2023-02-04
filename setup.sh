#!/bin/bash

#  ____  _               _                  _
# / ___|| |__   __ _ ___| |____      ____ _| |_
# \___ \| '_ \ / _` / __| '_ \ \ /\ / / _` | __|
#  ___) | | | | (_| \__ \ | | \ V  V / (_| | |_
# |____/|_| |_|\__,_|___/_| |_|\_/\_/ \__,_|\__|
#
#     _                                 _
#    / \   __ _ _ __ __ ___      ____ _| |
#   / _ \ / _` | '__/ _` \ \ /\ / / _` | |
#  / ___ \ (_| | | | (_| |\ V  V / (_| | |
# /_/   \_\__, |_|  \__,_| \_/\_/ \__,_|_|
#         |___/

# WARNING: Run this script at your own risk.

echo ""
echo "******************************************"
echo "**  This script is still in Beta face   **"
echo "** It's only meant to run on Arch Linux **"
echo "******************************************"
echo ""

read -p "Do you still want to install (Y/n)? " install_confirm

if [[ $install_confirm =~ ^[Nn]$ ]]; then
    echo "You choose not to use the script."
    exit 0
fi

echo "Starting Installation..."
sleep 2

echo ""
echo "******************************************************"
echo "** Installing Dependencies, this may take some time **"
echo "******************************************************"
echo ""

if ! sudo pacman --needed --ask 4 -Sy - < pkg_list.txt; then
    echo "Error: pacman installation failed."
    exit 1
fi

if ! pip install psutil; then
    echo "Error: psutil installation failed."
    exit 1
fi

if ! git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh; then
    echo "Error: oh-my-zsh installation failed."
    exit 1
fi

if ! chsh -s $(which zsh); then
    echo "Error: failed shell change."
    exit 1
fi

if ! git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k; then
    echo "Error: failed installing powerlevel10k."
    exit 1
fi

if ! git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim; then
    echo "Error: failed installing packer"
    exit 1
fi

if ! git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions; then
    echo "Error: failed installing zsh-autosuggestions."
    exit 1
fi

if ! git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting; then
    echo "Error: failed installing zsh-syntax-highlighting."
    exit 1
fi

if ! git clone https://github.com/ShashwatAgrawal20/wallpaper.git ~/Pictures/wallpaper; then
    echo "Error: failed installing wallpapers"
    exit 1
fi

if ! (git clone https://aur.archlinux.org/paru-bin ~/Downloads/ && cd ~/Downloads/paru-bin/ && makepkg -si); then
    echo "Error: failed installing paru"
    exit 1
fi

if ! nitrogen --set-scaled --random --save ~/Pictures/wallpaper/; then
    echo "Error: failed to set the wallpaper"
    exit 1
fi

echo ""
echo "*******************************************************************"
echo "**              Moving the files to their location               **"
echo "*******************************************************************"
echo ""

# There might be a better way of implementing this, but for now it is what it is
mv $PWD ~/dotfiles
cd ~/dotfiles/.config/dmenu && sudo make install && sudo rm config.h && cd ~/dotfiles

# Creating symbolic links
ln -sf ~/dotfiles/.config/qtile ~/.config/
ln -sf ~/dotfiles/.vimrc ~/
ln -sf ~/dotfiles/.zshrc ~/
ln -sf ~/dotfiles/.p10k.zsh ~/
ln -sf ~/dotfiles/.config/rofi ~/.config/
ln -sf ~/dotfiles/.config/kitty/ ~/.config/
ln -sf ~/dotfiles/.config/nvim ~/.config
ln -sf ~/dotfiles/.config/picom ~/.config

nvim -u ~/.config/nvim/lua/theprimeagen/packer.lua -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

echo ""
echo "Installation Successfully Completed" | cowsay
echo ""

while true; do
    read -p "Do you want to reboot to get your dtos? [Y/n] " yn
    case $yn in
        [Yy]* ) reboot;;
        [Nn]* ) break;;
        "" ) reboot;;
        * ) echo "Please answer yes or no.";;
    esac
done
