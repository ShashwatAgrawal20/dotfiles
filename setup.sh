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
    sudo pacman -S --needed qtile base-devel nitrogen vim zsh curl cowsay otf-font-awesome ttf-font-awesome powerline-fonts ttf-jetbrains-mono python-pip && \
        pip install psutil && \
        curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && \
        git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh && \
        cp ~/.zshrc ~/.zshrc.orig && \
        chsh -s $(which zsh) && \
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k && \
        sudo git clone https://github.com/ShashwatAgrawal20/wallpaper.git /usr/share/backgrounds/custom

    vim -c 'PlugInstall' -c qa

    nitrogen --set-scaled --random --save /usr/share/backgrounds/custom

    echo ""
    echo "*******************************************************************"
    echo "**              Moving the files to their location               **"
    echo "*******************************************************************"
    echo ""

    # There might be a better way of implementing this, but for now it is what it is
    mv $PWD ~/dotfiles
    cd ~/dotfiles/.config/dmenu && sudo make install && sudo rm config.h && cd ~/dotfiles

    # Creating symbolic links 
    ln -s ~/dotfiles/.config/qtile ~/.config/
    ln -s ~/dotfiles/.vimrc ~/
    ln -s ~/dotfiles/.zshrc ~/
    ln -s ~/dotfiles/.p10k.zsh ~/

    echo ""
    echo "Installation Successfully Completed" | cowsay
    echo ""

fi
