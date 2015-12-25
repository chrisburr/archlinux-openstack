#!/bin/bash -e

# Update and install basic packages
sudo pacman -Syy
sudo pacman --noconfirm -Syu
sudo pacman --noconfirm -S base-devel zsh tmux wget git svn

# Run gpg to make the config directory then enable auto-key-retrieve
gpg --list-keys
wget -O ~/.gnupg/gpg.conf https://gist.githubusercontent.com/chrisburr/3e3a5f34def0a5a9f5d7/raw/a0ed8b2b3e335cd803b746495b28da0f95fc1d2d/gpg.conf

# Install pacaur
mkdir ~/Downloads
cd ~/Downloads

git clone https://aur.archlinux.org/cower.git
cd cower
makepkg --noconfirm -sri
cd ..

git clone https://aur.archlinux.org/pacaur.git
cd pacaur
makepkg --noconfirm -sri
cd ..

# Install openafs
pacaur --noconfirm --noedit -S openafs openafs-modules-dkms linux-headers
sudo systemctl enable openafs-client
sudo systemctl start openafs-client

# TODO Make service to keep the keytab

# Install miniconda and make a couple of default enviroments
cd ~/Downloads
wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh -b -p $HOME/miniconda

export PATH="$HOME/miniconda/bin:$PATH"
conda create -y --name python-2.7 python=2.7 anaconda
conda create -y --name python-3.5 python=3.5 anaconda

# Install oh-my-zsh
sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
git clone git://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
