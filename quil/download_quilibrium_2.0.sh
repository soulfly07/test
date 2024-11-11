#!/bin/bash

# Параметры
OS="linux"
ARCH="amd64"
BASE_URL="https://releases.quilibrium.com"

# Цвета
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # Сброс цвета

# Установка необходимых утилит
echo "Установка необходимых утилит ..."
sudo apt update -qq && sudo apt install -y -qq wget curl

# Оставнока ceremonyclient
echo
echo -e "${YELLOW}Оставнока ceremonyclient ...${NC}"
echo
sudo systemctl stop ceremonyclient

# Поиск папки ceremonyclient
echo "Поиск папки ceremonyclient..."
CEREMONY_DIR=$(find / -type d -name "ceremonyclient" 2>/dev/null | head -n 1)

# Проверка, была ли найдена папка
if [ -z "$CEREMONY_DIR" ]; then
    echo "Папка ceremonyclient не найдена."
    exit 1
else
    echo "Папка ceremonyclient найдена: $CEREMONY_DIR"
    cd "$CEREMONY_DIR/node" || exit
fi

# Получение версии ноды и списка файлов для скачивания
echo "Получение версии ноды и списка файлов для скачивания..."
VERSION=$(curl -s "${BASE_URL}/release" | grep -oP '(?<=node-)[0-9]+\.[0-9]+\.[0-9]+(\.[0-9]+)?(?=-linux)' | head -n 1)

# Проверка, удалось ли получить версию
if [ -z "$VERSION" ]; then
    echo "Не удалось определить версию ноды."
    exit 1
else
    echo "Обнаружена версия ноды: $VERSION"
fi

# Получение списка файлов для скачивания с фильтрацией по ОС и архитектуре
FILE_LIST=$(curl -s "${BASE_URL}/release" | grep "node-${VERSION}-${OS}-${ARCH}")

# Проверка, нашлись ли файлы
if [ -z "$FILE_LIST" ]; then
    echo "Не удалось найти файлы для скачивания на странице."
    exit 1
fi

# Скачивание всех файлов с перезаписью
for FILE in $FILE_LIST; do
    FULL_URL="${BASE_URL}/${FILE}"
    echo "Скачивание $FULL_URL..."
    wget -O "$(basename "$FILE")" "$FULL_URL"
done

# Применение chmod +x к основному бинарному файлу
chmod +x "node-${VERSION}-${OS}-${ARCH}"

# Сообщение о завершении скачивания
echo
echo "Все файлы версии ${VERSION} успешно скачаны и обновлены."
echo

# Обновление файла ceremonyclient.service с новой версией
SERVICE_FILE="/lib/systemd/system/ceremonyclient.service"
echo "Обновление ${SERVICE_FILE} с новой версией..."
sudo sed -i "s|^ExecStart=.*|ExecStart=${CEREMONY_DIR}/node/node-${VERSION}-${OS}-${ARCH}|" "$SERVICE_FILE"

# Перезагрузка systemd для применения изменений
sudo systemctl daemon-reload

# Запуск ceremonyclient
echo
echo -e "${YELLOW}Запуск ceremonyclient ...${NC}"
sudo systemctl start ceremonyclient
echo

# Пауза перед проверкой версии
sleep 5

# Проверка версии ноды
echo -e "${GREEN}ПРОВЕРКА ВЕРСИИ${NC}"
echo
journalctl -u ceremonyclient -r --no-hostname -n 1 -g "Quilibrium Node" -o cat
echo
