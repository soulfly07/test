
#echo "deb http://cz.archive.ubuntu.com/ubuntu mantic main" >> /etc/apt/sources.list && apt update && apt install libc6

cd /root
mkdir waglayala 
cd waglayala 
wget -O wala-miner-cpu-linux.zip https://github.com/RacerCommunity/wala-miner/releases/download/v0.1.0/wala-miner-cpu-linux.zip
unzip -oj wala-miner-cpu-linux.zip
chmod +x *

screen -dmS wala-miner1 bash -c 'while true; do ./wala-miner --mining-address $1 --wala-address $2 --port 12110 ; done'
