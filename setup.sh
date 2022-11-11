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
    sudo pacman --needed --ask 4 -Sy - < pkg_list.txt || echo "Something went Wrong" && \
        pip install psutil && \
        curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && \
        git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh && \
        cp ~/.zshrc ~/.zshrc.orig && \
        chsh -s $(which zsh) && \
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k && \
        sudo git clone https://github.com/ShashwatAgrawal20/wallpaper.git /usr/share/backgrounds

    vim -c 'PlugInstall' -c qa

    nitrogen ---scaled --random --save /usr/share/backgrounds/wallpaper

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
