#echo "deb http://cz.archive.ubuntu.com/ubuntu mantic main" >> /etc/apt/sources.list && apt update && apt install libc6 -y

cd /root
wget -O Linux.-.waglayalad-rusty.zip https://github.com/user-attachments/files/17392272/Linux.-.waglayalad-rusty.zip
unzip Linux.-.waglayalad-rusty.zip
mkdir waglayala && mv 'Linux - waglayalad-rusty'/* waglayala
rm -r 'Linux - waglayalad-rusty' Linux.-.waglayalad-rusty.zip
cd waglayala 
wget -O waglaylaminer https://github.com/soulfly07/test/raw/refs/heads/main/waglaylaminer
wget -O waglaylawallet https://github.com/soulfly07/test/raw/refs/heads/main/waglaylawallet
chmod +x *

screen -dmS waglaylad ./waglaylad --utxoindex --rpclisten-borsh=public 
echo "Пауза 10 секунд что бы нода загрузилась, после старта майнер может быть с 0 хешей, значит что нода еще не догнала блоки, просто ждать"
sleep 10

screen -dmS waglaylaminer ./waglaylaminer --miningaddr $1

#с=$2
#for i in {1..$c}; do screen -dmS waglaylaminer$i ./waglaylaminer --miningaddr $1 ; done
