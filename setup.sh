#!/bin/bash

# Author: Shashwat Agrawal
# Github: ShashwatAgrawal20
# I know, it's a shitty script, but hey, it is what it is.

# Georgeous Variables
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'
backup_dir="$HOME/dotfiles_backup_$(date +'%Y-%m-%d_%H:%M:%S')"
github_items=(
    "https://github.com/ohmyzsh/ohmyzsh.git $HOME/.oh-my-zsh Oh-My-Zsh"
    "https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions Zsh-Autosuggestions"
    "https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting Zsh-Syntax-Highlighting"
    "https://github.com/ShashwatAgrawal20/wallpaper.git $HOME/Pictures/wallpaper Wallpapers"
)
backup_list=(
    "$HOME/.zshrc"
    "$HOME/.tmux.conf"
    "$HOME/.clang-format"
    "$HOME/.fehbg"
    "$HOME/.tmux-cht-command"
    "$HOME/.tmux-cht-languages"
    "$HOME/.local/bin"
    "$HOME/.config/qtile"
    "$HOME/.config/nvim"
    "$HOME/.config/rofi"
    "$HOME/.config/dunst"
    "$HOME/.config/picom"
    "$HOME/.config/kitty"
    "$HOME/.config/i3"
    "$HOME/.config/i3status"
    "$HOME/.config/hypr"
    "$HOME/.config/waybar"
    "$HOME/.config/dmenu"
    "$HOME/.config/clangd"
)

# Georgeous Functions
error() {
    echo -e "${RED}Error: $1${NC}" >&2
}
success() {
    echo -e "${GREEN}$1${NC}"
}
warning() {
    echo -e "${YELLOW}Warning: $1${NC}"
}
backup() {
    local source_path="$1"
    if [ -e "$source_path" ]; then
        mv "$source_path" "$backup_dir/" 2>/dev/null && success "Backed up: $source_path to $backup_dir/" || warning "Failed to back up: $source_path"
    fi
}
install_git_repo() {
    local repo_url="$1"
    local target_dir="$2"
    local item_name="$3"
    if [ ! -d "$target_dir" ]; then
        git clone --depth=1 "$repo_url" "$target_dir" || error "Failed installing $item_name."
    else
        warning "$item_name is already installed in $target_dir. Skipping."
    fi
}
mkdir -p $backup_dir

echo ""
echo "******************************************"
echo "**  This script is still in Beta face   **"
echo "** It's only meant to run on Arch Linux **"
echo "******************************************"
echo ""

read -rp "Do you still want to install (Y/n)? " install_confirm

if [[ $install_confirm =~ ^[Nn]$ ]]; then
    warning "You chose not to use the script. Exiting."
    exit 0
fi

echo "Starting Installation..."
sleep 2

# Backup is essential
echo ""
echo "******************************************************"
echo "** Backing up the sutff that's going to be modified **"
echo "******************************************************"
echo ""

for item in "${backup_list[@]}"; do
    backup "$item"
done

echo ""
echo "******************************************************"
echo "** Installing Dependencies, this may take some time **"
echo "******************************************************"
echo ""

if ! sudo pacman --needed --ask 4 -Sy - < pkg_list.txt; then
    error "failed to install dependencies."
    exit 1
fi

for item in "${github_items[@]}"; do
    read -r repo_url target_dir item_name <<< "$item"

    echo "Installing $item_name..."
    install_git_repo "$repo_url" "$target_dir" "$item_name"
done

if ! chsh -s $(which zsh); then
    error "failed changing default shell to zsh."
fi

if ! command -v paru &> /dev/null; then
    echo "Installing paru..."
    if ! (git clone https://aur.archlinux.org/paru-bin "$HOME/Downloads/paru-bin/" && cd "$HOME/Downloads/paru-bin/" && makepkg -si); then
        warning "Failed to install paru."
    fi
else
    warning "paru is already installed. Skipping installation."
fi

echo ""
echo "*******************************************************************"
echo "**              Moving the files to their location               **"
echo "*******************************************************************"
echo ""

# There might be a better way of implementing this, but for now it is what it is
mv $PWD $HOME/dotfiles
mkdir -p "$HOME/.local/bin"
cd .config/dmenu && sudo make clean install && sudo rm config.h

# Creating symbolic links
ln -sf $HOME/dotfiles/.zshrc $HOME/
ln -sf $HOME/dotfiles/.fehbg $HOME/
ln -sf $HOME/dotfiles/.clang-format $HOME/
ln -sf $HOME/dotfiles/.tmux.conf $HOME/
ln -sf $HOME/dotfiles/.tmux-* $HOME/
ln -sf $HOME/dotfiles/.local/bin/* $HOME/.local/bin/
ln -sf $HOME/dotfiles/.config/* $HOME/.config/

echo ""
echo "Installation Successfully Completed" | cowsay
echo ""

while true; do
    read -p "Do you want to reboot? [Y/n] " yn
    case $yn in
        [Yy]* ) reboot;;
        [Nn]* ) break;;
        "" ) reboot;;
        * ) echo "Please answer yes or no.";;
    esac
done
