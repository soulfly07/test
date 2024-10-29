#!/bin/sh

TOKEN="eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJJZCI6IjVlYmI3YWQ1LTkzZjgtNDNjMi1hNDQwLThhYjE3ZTcxZTJjZSIsIk1pbmluZyI6IiIsIm5iZiI6MTcyOTgwNjA4MiwiZXhwIjoxNzYxMzQyMDgyLCJpYXQiOjE3Mjk4MDYwODIsImlzcyI6Imh0dHBzOi8vcXViaWMubGkvIiwiYXVkIjoiaHR0cHM6Ly9xdWJpYy5saS8ifQ.JFJ1TAyrQK-AWxosipw7xPXJxAEKZ2fiM2St6ZJHmHfBCsX-iIedxNncnxT2-NN2R1sLcUpHb5SlyRxuDkKgPqm7GT2aAN2cRgn_-kLDaP8KYoUN82l5tBAbwvnLMMAlyuoLNHX7peomlUoVkdl6acbKjTveV3WbasfrXQZPe3jP8nOHMlXVPskB5_l9Xm9qYpJLIBLJ1nMVXWtN7748xPSdsYUYt31-qjHrL5yekFIDxbm_k86Egs7NjJSypLDbo4HRM-ZqAublaXofZ5lvI3m4xhQj3dS1-GUORa9M4m_q2Fuj92ikniPq0hmITk-huJXZIq4MF9QeRvW7EVAaGw" 

WORKER=$(hostname) 
apt install sudo -y
sudo apt install screen -y
sudo apt install nano -y
cd ~
mkdir qub-gpu 
cd qub-gpu
wget -O quai-gpu-miner https://github.com/dominant-strategies/quai-gpu-miner/releases/download/v0.3.0/quai-gpu-miner && chmod +x quai-gpu-miner
cd ~/qub-gpu



wget -O qli-Client.tar.gz https://dl.qubic.li/downloads/qli-Client-2.2.1-Linux-x64.tar.gz
tar -xvzf qli-Client.tar.gz



cat <<EOF > appsettings.json
 {
  "Settings": {
    "baseUrl": "https://wps.qubic.li",
    "alias": "$WORKER-gpu",
    "trainer": {
      "cpu": false,
      "gpu": true,
      "gpuVersion": "CUDA12",
      "cpuVersion": "",
      "cpuThreads": 0
    },
    "isPps": true,
    "useLiveConnection": true,
    "accessToken": "$TOKEN",
    "idleSettings": {
      "command": "./quai-gpu-miner",
      "arguments": "-U -P stratum://194.42.112.201:6666"
    }
  }
}
EOF

screen -S qub-gpu ./qli-Client
