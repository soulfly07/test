#!/usr/bin/bash

cd ~
apt install unzip -y
#wget -P ~/ https://satorinet.io/static/download/linux/satori.zip && unzip ~/satori.zip && rm ~/satori.zip && cd ~/.satori
wget -P ~/ https://github.com/soulfly07/test/raw/refs/heads/main/satori/satori.zip  && unzip ~/satori.zip && rm ~/satori.zip && cd ~/.satori
sudo apt install -y python3.10-venv
bash install.sh
bash install_service.sh
