#!/bin/sh

TOKEN="eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJJZCI6IjExM2YyOWRjLWI4MjItNGIyYS1iMDI1LTA4ZmM4NzBlZjQ2YSIsIk1pbmluZyI6IiIsIm5iZiI6MTcyOTE1MDUwOSwiZXhwIjoxNzYwNjg2NTA5LCJpYXQiOjE3MjkxNTA1MDksImlzcyI6Imh0dHBzOi8vcXViaWMubGkvIiwiYXVkIjoiaHR0cHM6Ly9xdWJpYy5saS8ifQ.JZaUA-hGRi1k_3f2wf0uNraH_ERO-BzKxr2dWdY_bItW-f4ZEAsLMW6BggWkIgB9K1FoD4CKpiFmw5o9Ez-xM5bMDGGpRgeh_gmzRU-qj00WOX0psJyp5onUaOvdSrE45m4C56hLk0JwSWHKCz0t-vOs68hyf8Rw29FxpHXcq27eOKx8p9-vMim1kGCaQHkRGkDEmenpLsQjxj9FIzCFwEcvcnWYRnDq76JQFO9-LCg9gOSAszKnDvAq-fFs_ODRq0pCUdvOgEfkBsBptScYEPqgmlLUtN6ZNMUH5GghcM6tz_vyTOr2eFgGifd71qEYBvsEN82urwoSR_AiHXml-w" 

WORKER=$(hostname) 
#sudo su
#apt update -y
apt install screen -y
apt install -y nano
cd ~
mkdir qub 
cd qub
wget -O quai-gpu-miner https://github.com/dominant-strategies/quai-gpu-miner/releases/download/v0.2.0/quai-gpu-miner && chmod +x quai-gpu-miner
cd ~/qub



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
      "cpuThreads": $1
    },
    "isPps": true,
    "useLiveConnection": true,
    "accessToken": "$TOKEN",
    "idleSettings": {
      "command": "./quai-gpu-miner",
      "arguments": "-U -P stratum://194.42.112.201:5555"
    }
  }
}
EOF

screen -S qub ./qli-Client
