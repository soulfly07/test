#!/bin/bash

show() {
  echo "$1"
}

showw() {
    echo -e "\033[33m$1\033[0m"
}


if ! [ -x "$(command -v curl)" ]; then
  show "curl не установлен. Пожалуйста, установите его, чтобы продолжить."
  exit 1
else
  show "curl уже установлен."
fi

# Получаем внешний IP адрес
IP=$(curl -s ifconfig.me)
if [ -z "$IP" ]; then
  show "Не удалось получить внешний IP адрес."
  exit 1
fi

# Запрашиваем имя пользователя
read -p "Введите имя пользователя: " USERNAME

# Запрашиваем пароль, ввод будет скрытым
read -s -p "Введите пароль: " PASSWORD
echo  # Переход на новую строку для красивого отображения
read -s -p "Подтвердите пароль: " PASSWORD_CONFIRM
echo  # Переход на новую строку

# Проверяем, совпадают ли пароли
if [ "$PASSWORD" != "$PASSWORD_CONFIRM" ]; then
  show "Пароли не совпадают. Пожалуйста, запустите скрипт заново и введите пароли правильно."
  exit 1
fi

CREDENTIALS_FILE="$HOME/vps-browser-credentials.json"
cat <<EOL > "$CREDENTIALS_FILE"
{
  "username": "$USERNAME",
  "password": "$PASSWORD"
}
EOL

if ! [ -x "$(command -v docker)" ]; then
  show "Docker не установлен. Устанавливаю Docker..."
  curl -fsSL https://get.docker.com -o get-docker.sh
  sudo sh get-docker.sh
  if [ -x "$(command -v docker)" ]; then
    show "Docker успешно установлен."
  else
    show "Не удалось установить Docker."
    exit 1
  fi
else
  show "Docker уже установлен."
fi

show "Загрузка последнего образа Docker с Chromium..."
if ! docker pull linuxserver/chromium:latest; then
  show "Не удалось загрузить образ Docker с Chromium."
  exit 1
else
  show "Образ Docker с Chromium успешно загружен."
fi

mkdir -p "$HOME/chromium/config"

if [ "$(docker ps -q -f name=browser1)" ]; then
    show "Контейнер с Chromium уже запущен."
else
    show "Запуск контейнера с Chromium..."

    # Выводим параметры для проверки
    show "Имя пользователя: $USERNAME"
    show "Пароль: скрыт"

    # Запускаем контейнер
    docker run -d --name browser1 \
      --privileged \
      -e TITLE=$(hostname) \
      -e DISPLAY=:1 \
      -e PUID=1000 \
      -e PGID=1000 \
      -e CUSTOM_USER="$USERNAME" \
      -e PASSWORD="$PASSWORD" \
      -e LANGUAGE=en_US.UTF-8 \
      -v "$HOME/chromium/config:/config" \
      -p 10000:3000 \
      --shm-size="2gb" \
      --restart unless-stopped \
      lscr.io/linuxserver/chromium:latest

    if [ $? -eq 0 ]; then
        show "Контейнер с Chromium успешно запущен."
    else
        show "Не удалось запустить контейнер с Chromium."
        exit 1
    fi
fi

showw "Откройте этот адрес http://$IP:10000/ для запуска браузера извне"
showw "Введите это имя пользователя: $USERNAME в браузере"
showw "Введите этот пароль : $PASSWORD в браузере"
