#!/bin/sh

#$1=TOKEN
#$2=PPS
#$3=QUAISTRATUM

TOKEN="eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJJZCI6ImNlOWY1YTdmLWQxZDktNDU1Ny05ZDM5LWFhMGU2ZWM0NjkwMyIsIk1pbmluZyI6IiIsIm5iZiI6MTczMDAxNTg5NCwiZXhwIjoxNzYxNTUxODk0LCJpYXQiOjE3MzAwMTU4OTQsImlzcyI6Imh0dHBzOi8vcXViaWMubGkvIiwiYXVkIjoiaHR0cHM6Ly9xdWJpYy5saS8ifQ.UqU0b0zJqcD_LTNyojhyEpTULzLT_SC4FEFmvGpiv4qKTpljUx2cfFTPiB-eiXSCsJCFSd6_RWt5L4GtZSpc2kXhK7zfxYOB3syYZ8bbFurtERQGSMoqm5cslEg1MrZ4YKyOMCIv9JtWSvAfWj7rOa7W-R5VX29dTa91zrO71AZ22KhUc5B75h86hhOVavAGz-5p36r5dgNqPSqf9PiHcRvxsacjLWQpjWVricKii2HyN09p85X7w8IHxi649x_zkbf883gTKv_JMVrPG1Z2o4cfdtNLbcRA8VSjxDjbCgJvgkXz74BVK-6vDlDIqjgLDPnOiPypLt-_oofi0vhe9g"

PPS="true"
QUAISTRATUM="stratum://194.190.97.223:3333"

WORKER=$(hostname) 

apt install sudo -y
sudo apt install screen -y
sudo apt install -y nano
cd ~
mkdir qub-gpu 
cd qub-gpu
wget -O quai-gpu-miner https://github.com/dominant-strategies/quai-gpu-miner/releases/download/v0.2.0/quai-gpu-miner && chmod +x quai-gpu-miner
cd ~/qub-gpu



wget -O qli-Client.tar.gz https://dl.qubic.li/downloads/qli-Client-2.2.1-Linux-x64.tar.gz
tar -xvzf qli-Client.tar.gz



cat <<EOF > appsettings.json
 {
  "Settings": {
    "baseUrl": "https://wps.qubic.li",
    "alias": "$WORKER",
    "trainer": {
      "cpu": false,
      "gpu": true,
      "gpuVersion": "CUDA12",
      "cpuVersion": "",
      "cpuThreads": 0
    },
    "isPps": $PPS,
    "useLiveConnection": true,
    "accessToken": "$TOKEN",
    "idleSettings": {
      "command": "./quai-gpu-miner",
      "arguments": "-U -P $QUAISTRATUM"
    }
  }
}
EOF

screen -S qub ./qli-Client
