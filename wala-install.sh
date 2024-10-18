
echo "deb http://cz.archive.ubuntu.com/ubuntu mantic main" >> /etc/apt/sources.list && apt update && apt install libc6

cd /root
wget -O Linux.-.waglayalad-rusty.zip https://github.com/user-attachments/files/17392272/Linux.-.waglayalad-rusty.zip
unzip Linux.-.waglayalad-rusty.zip
mkdir waglayala && mv 'Linux - waglayalad-rusty'/* waglayala
rm -r 'Linux - waglayalad-rusty' Linux.-.waglayalad-rusty.zip
cd waglayala 
#wget -O waglaylaminer https://github.com/soulfly07/test/raw/refs/heads/main/waglaylaminer
wget -O wala-miner-cpu-linux.zip https://github.com/RacerCommunity/wala-miner/releases/download/v0.1.0/wala-miner-cpu-linux.zip
unzip -oj wala-miner-cpu-linux.zip
wget -O waglaylawallet https://github.com/soulfly07/test/raw/refs/heads/main/waglaylawallet
chmod +x *

screen -dmS waglaylad ./waglaylad --utxoindex --rpclisten=0.0.0.0:12110 --rpclisten-borsh=public 
echo "Пауза 20 секунд что бы нода загрузилась, после старта майнер может быть с 0 хешей, значит что нода еще не догнала блоки, просто ждать"
sleep 20


#screen -dmS wala-miner ./wala-miner --mining-address $1 --wala-address 127.0.0.1 --port 12110
screen -S wala-miner0 bash -c 'while true; do ./wala-miner --mining-address $1 --wala-address 192.168.31.203 --port 12110 ; done'
