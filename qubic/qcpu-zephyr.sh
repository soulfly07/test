#!/bin/sh

TOKEN="eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJJZCI6IjVlYmI3YWQ1LTkzZjgtNDNjMi1hNDQwLThhYjE3ZTcxZTJjZSIsIk1pbmluZyI6IiIsIm5iZiI6MTcyOTgwNjA4MiwiZXhwIjoxNzYxMzQyMDgyLCJpYXQiOjE3Mjk4MDYwODIsImlzcyI6Imh0dHBzOi8vcXViaWMubGkvIiwiYXVkIjoiaHR0cHM6Ly9xdWJpYy5saS8ifQ.JFJ1TAyrQK-AWxosipw7xPXJxAEKZ2fiM2St6ZJHmHfBCsX-iIedxNncnxT2-NN2R1sLcUpHb5SlyRxuDkKgPqm7GT2aAN2cRgn_-kLDaP8KYoUN82l5tBAbwvnLMMAlyuoLNHX7peomlUoVkdl6acbKjTveV3WbasfrXQZPe3jP8nOHMlXVPskB5_l9Xm9qYpJLIBLJ1nMVXWtN7748xPSdsYUYt31-qjHrL5yekFIDxbm_k86Egs7NjJSypLDbo4HRM-ZqAublaXofZ5lvI3m4xhQj3dS1-GUORa9M4m_q2Fuj92ikniPq0hmITk-huJXZIq4MF9QeRvW7EVAaGw" 

WORKER=$(hostname) 

apt install sudo
sudo apt install screen -y
sudo apt install -y nano tar zip -y
sudo apt install screen xz-utils -y 
cd ~
mkdir qub-zephyr 
cd qub-zephyr

wget -O qli-Client.tar.gz https://dl.qubic.li/downloads/qli-Client-2.2.1-Linux-x64.tar.gz
tar -xvzf qli-Client.tar.gz

wget -O SRBMiner-Multi-2-6-9-Linux.tar.gz https://github.com/doktor83/SRBMiner-Multi/releases/download/2.6.9/SRBMiner-Multi-2-6-9-Linux.tar.gz
tar -xvzf SRBMiner-Multi-2-6-9-Linux.tar.gz


cat <<EOF > appsettings.json
 {
  "Settings": {
    "baseUrl": "https://wps.qubic.li",
    "alias": "$WORKER",
    "trainer": {
      "cpu": true,
      "gpu": false,
      "gpuVersion": "CUDA12",
      "cpuVersion": "",
      "cpuThreads": $1
    },
    "isPps": true,
    "useLiveConnection": true,
    "accessToken": "$TOKEN",
    "idleSettings": {
      "command": "SRBMiner-Multi-2-6-9/SRBMiner-MULTI",
      "arguments": "--algorithm randomx --pool de.zephyr.herominers.com:1123 --wallet ZEPHsBwVwAj6GZnyYq1HAvVHY2RDRovrCYm18tTtZu3rTkzampXDmEvDPzAxsCpQRnBEYhgmPeBf8ibqbJ1zUPzk7PMD3EHtnuG --password $(hostname)"
    }
   }
}
EOF

if ! command -v ts &> /dev/null; then
    echo "Program ts (moreutils) - not installed. ts is required. Installing..."
    cd /tmp/ && wget -O ts https://raw.githubusercontent.com/Worm/moreutils/master/ts && sudo mv ts /usr/local/bin && sudo chmod 777 /usr/local/bin/ts
    echo "Program ts (moreutils) - has been installed."
fi

cd ~/qub-zephyr
screen -S qub ./qli-Client | ts | tee --append miner.log
