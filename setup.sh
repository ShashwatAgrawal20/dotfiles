#!/bin/bash

echo "" 
echo "*******************************************************************"
echo "**               This script is still in Beta face               **"
echo "**               It's only ment to run on arch linux             **"
echo "*******************************************************************"
echo "" 

while true; do
    read -p "Do you still want to install (Yy, Nn)- " install_confirm
    if [[ $install_confirm = 'N' || $install_confirm = 'n' ]]; then
        echo "You choose not to use the script"
        break;

    elif [[ $install_confirm = 'Y' || $install_confirm = 'y' ]]; then
        echo "Starting Installation"
        sleep 2
        break;

    else
        echo "Something went Wrong" 
fi
done

if [[ $install_confirm = 'Y' || $install_confirm = 'y' ]]; then

    echo "" 
    echo "*******************************************************************"
    echo "**        Installing Dependencies, this may take some time       **"
    echo "*******************************************************************"
    echo ""

    (sudo pacman --needed --ask 4 -Sy - < pkg_list.txt || echo "Something went Wrong") && \
        (pip install psutil || echo "psutil installation failed") && \
        (curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim || echo "vim-plug installation failed") && \
        (sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim' || echo "unable to get vim-plug from nvim") && \
        (git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh || echo "oh-my-zsh installation failed") && \
        (cp ~/.zshrc ~/.zshrc.orig || echo "original zshrc config copy failed") && \
        (chsh -s $(which zsh) || echo "failed shell change") && \
        (git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k || echo "failed installing powerlevel10k") && \
        (git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions || echo "failed installing zsh-autosuggestions") && \
        (git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting || echo "failed installing zsh-syntax-highlighting") && \
        (git clone https://github.com/ShashwatAgrawal20/wallpaper.git ~/Pictures/wallpaper || echo "wallpaper cloning failed")

    nvim -c 'PlugInstall' -c qa

    (nitrogen --set-scaled --random --save ~/Pictures/wallpaper/ || echo "failed to set wallpaper")

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

    echo ""
    echo "Installation Successfully Completed" | cowsay
    echo ""

fi