#!/usr/bin/bash

cd ~
wget -P ~/ https://satorinet.io/static/download/linux/satori.zip && unzip ~/satori.zip && rm ~/satori.zip && cd ~/.satori
sudo apt install -y python3.10-venv
bash install.sh
bash install_service.sh
