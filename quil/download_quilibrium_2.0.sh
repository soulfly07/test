#!/bin/bash

# Параметры
OS="linux"
ARCH="amd64"
BASE_URL="https://releases.quilibrium.com/node-2.0.0-${OS}-${ARCH}"

# Установка wget
echo "Установка wget..."
sudo apt update -qq && sudo apt install -y -qq wget

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

# Список файлов для скачивания
FILES=(
    "${BASE_URL}"
    "${BASE_URL}.dgst"
    "${BASE_URL}.dgst.sig.1"
    "${BASE_URL}.dgst.sig.3"
    "${BASE_URL}.dgst.sig.4"
    "${BASE_URL}.dgst.sig.6"
    "${BASE_URL}.dgst.sig.8"
    "${BASE_URL}.dgst.sig.9"
    "${BASE_URL}.dgst.sig.13"
    "${BASE_URL}.dgst.sig.15"
    "${BASE_URL}.dgst.sig.16"
)

# остановка ceremonyclient
systemctl stop ceremonyclient

# Скачивание всех файлов с перезаписью и без вывода на экран
for FILE in "${FILES[@]}"; do
    echo "Скачивание $FILE..."
    wget -O "$(basename "$FILE")" "$FILE"
done

# Применение chmod +x к файлу ${BASE_URL} с перезаписью
chmod +x "$(basename "${BASE_URL}")"

# Создание временного скрипта для удаления
echo "rm -- \"$0\"" > /tmp/delete_script.sh
chmod +x /tmp/delete_script.sh

# Выполнение временного скрипта
/tmp/delete_script.sh

echo "Все файлы успешно скачаны, chmod +x применен к файлу $(basename "${BASE_URL}")."


