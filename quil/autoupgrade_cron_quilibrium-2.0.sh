#!/bin/bash

# Найти папку ceremonyclient
CEREMONY_DIR=$(find / -type d -name "ceremonyclient" 2>/dev/null | head -n 1)

# Скачать скрипт папку node внутри ceremonyclient
wget -O "$CEREMONY_DIR/node/upgrade-quilibrium-2.0.sh" https://github.com/soulfly07/test/raw/refs/heads/main/quil/upgrade-quilibrium-2.0.sh

# Сделать скрипт исполняемым
chmod +x "$CEREMONY_DIR/node/upgrade-quilibrium-2.0.sh"

# Добавить задание в crontab для выполнения скрипта каждые 5 минут с логированием
# Добавить задание в crontab для выполнения скрипта каждые 5 минут с логированием и меткой времени
(crontab -l 2>/dev/null; echo "*/5 * * * * (echo \"\$(date +'%Y-%m-%d %H:%M:%S') - Запуск скрипта:\" >> $CEREMONY_DIR/node/upgrade.log; $CEREMONY_DIR/node/upgrade-quilibrium-2.0.sh >> $CEREMONY_DIR/node/upgrade.log 2>&1)") | crontab -
