
#echo "deb http://cz.archive.ubuntu.com/ubuntu mantic main" >> /etc/apt/sources.list && apt update && apt install libc6

cd /root
mkdir -p waglayala
cd waglayala
wget -O wala-miner-cpu-linux.zip https://github.com/RacerCommunity/wala-miner/releases/download/v0.2.0/wala-miner-cpu-linux-0.2.0.zip
unzip -oj wala-miner-cpu-linux.zip
chmod +x *

# Запуск майнера в screen, передача аргументов через переменные
screen -dmS wala-miner1 bash -c "mining_address=$1; wala_address=$2; while true; do ./wala-miner --mining-address \$mining_address --wala-address \$wala_address --port 12110; done"


