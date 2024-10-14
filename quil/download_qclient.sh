#!/bin/bash

# Встановлення перемінних
BASE_URL="https://releases.quilibrium.com"
RELEASE_URL="${BASE_URL}/qclient-release"
OS="linux"
ARCH="amd64"

# Пошук папки ceremonyclient
CEREMONY_DIR=$(find / -type d -name "ceremonyclient" 2>/dev/null)

if [ -z "$CEREMONY_DIR" ]; then
    echo "Папка ceremonyclient не знайдена."
    exit 1
fi

# Визначення папки client для збереження файлів
CLIENT_DIR="${CEREMONY_DIR}/client"

# Створення папки client, якщо вона не існує
mkdir -p "$CLIENT_DIR"

# Отримання версії qclient
VERSION=$(curl -s "${RELEASE_URL}" | grep -oP 'qclient-\K[\d.]+(?=-linux)' | head -n 1)

# Список файлів для завантаження
FILES=$(curl -s "${RELEASE_URL}" | grep "qclient-${VERSION}-${OS}-${ARCH}")

# Перевірка наявності файлів
if [ -z "$FILES" ]; then
    echo "Файли для версії ${VERSION} не знайдені."
    exit 1
fi

# Завантаження файлів
echo "Завантаження файлів для версії ${VERSION} в папку ${CLIENT_DIR}..."
for FILE in $FILES; do
    echo "Завантаження ${FILE}..."
    wget --progress=bar -q "${BASE_URL}/${FILE}" -O "${CLIENT_DIR}/${FILE}" || { echo "Помилка при завантаженні ${FILE}"; exit 1; }
done

# Встановлення прав на виконання лише для основного бінарного файлу
MAIN_BINARY="qclient-${VERSION}-${OS}-${ARCH}"
if [ -f "${CLIENT_DIR}/${MAIN_BINARY}" ]; then
    chmod +x "${CLIENT_DIR}/${MAIN_BINARY}"
    echo "Права на виконання встановлено для ${MAIN_BINARY}."
else
    echo "Основний бінарний файл ${MAIN_BINARY} не знайдено."
fi

echo "Усі файли версії ${VERSION} успішно завантажено та оновлено в папку ${CLIENT_DIR}."

