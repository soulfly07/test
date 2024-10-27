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
      "command": " ~/qub/SRBMiner-Multi-2-6-9/SRBMiner-MULTI",
      "arguments": "--algorithm randomx --pool de.zephyr.herominers.com:1123 --wallet ZEPHs98Ej1cjbSXLAtbHYk3RMsL4RYWPfioWaPKx54ue7AimsXZP2R3eGwAnwwrwD9R8ads8GmkC88CoEQ96t3XUW27q15A7ur6 --password $(hostname)"
    }
   }
}
EOF

screen -S qub ./qli-Client
