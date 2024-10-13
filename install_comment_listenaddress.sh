#!/bin/bash

# Step 1: Создание скрипта для комментирования ListenAddress в /etc/ssh/sshd_config
echo "Создание скрипта для комментирования ListenAddress..."
cat <<EOF | sudo tee /usr/local/bin/comment_listen_address.sh > /dev/null
#!/bin/bash
# Комментирование строки ListenAddress 127.0.0.1
sed -i '/^ListenAddress 127\\.0\\.0\\.1/s/^/#/' /etc/ssh/sshd_config

# Перезапуск SSH-сервера
systemctl restart ssh

# Логирование времени выполнения
echo "Script executed at \$(date)" >> /var/log/comment_listen_address.log
EOF

# Step 2: Сделать скрипт исполняемым
echo "Делаем скрипт исполняемым..."
sudo chmod +x /usr/local/bin/comment_listen_address.sh

# Step 3: Создание службы systemd для запуска скрипта при загрузке системы
echo "Создание службы systemd..."
cat <<EOF | sudo tee /etc/systemd/system/comment-listenaddress.service > /dev/null
[Unit]
Description=Comment ListenAddress in sshd_config
After=network.target

[Service]
ExecStart=/usr/local/bin/comment_listen_address.sh
Type=oneshot

[Install]
WantedBy=multi-user.target
EOF

# Step 4: Создание таймера systemd для отложенного запуска службы
echo "Создание таймера systemd..."
cat <<EOF | sudo tee /etc/systemd/system/comment-listenaddress.timer > /dev/null
[Unit]
Description=Run comment_listen_address.sh 1 minute after boot

[Timer]
OnBootSec=1min
Unit=comment-listenaddress.service

[Install]
WantedBy=timers.target
EOF

# Step 5: Активация службы и таймера
echo "Активация службы и таймера..."
sudo systemctl enable comment-listenaddress.service
sudo systemctl enable comment-listenaddress.timer

# Step 6: Запуск таймера немедленно
echo "Запуск таймера немедленно..."
sudo systemctl start comment-listenaddress.timer

# Step 7: Удаление файла скрипта после выполнения
echo "Удаление файла скрипта..."
rm -- "\$0"
