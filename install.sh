#!/bin/bash
script_dir=$(dirname "$(readlink -f "$0")")

read -rsp "sudo passwd:" sudopasswd
echo $sudopasswd | sudo -S apt-get update

# install vim
echo $sudopasswd | sudo -S apt-get install vim
cp $script_dir/vimrc ~/.vimrc

# install bash_aliases
if [[ -f "~/.bash_aliases" ]]; then 
  cp $script_dir/bash_aliases ~/.bash_aliases
else
  echo "#========= config from ubuntu-setup =========" >> ~/.bash_aliases
  cat $script_dir/bash_aliases >> ~/.bash_aliases
fi

# install keyd
cd $script_dir/keyd
make
echo $sudopasswd | sudo -S make install
echo $sudopasswd | sudo -S systemctl enable keyd
echo $sudopasswd | sudo -S cp $script_dir/keyd.d/default.conf /etc/keyd/default.conf
echo $sudopasswd | sudo -S systemctl start keyd

source ~/.bashrc
