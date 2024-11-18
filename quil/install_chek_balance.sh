#!/bin/bash

SCRIPT_PATH=~/ceremonyclient/node/chek_balance.sh

cat << 'EOF' > "$SCRIPT_PATH"
#!/bin/bash
cd ~/ceremonyclient/node/
#Получаем первый балан
node-2.0.3.4-linux-amd64 --node-info | grep "Owned balance" | awk -v date="$(date '+%Y-%m-%d %H:%M:%S')" '{print date, $0}' >> balance.log

# Извлекаем текущее значение баланса без даты
current_balance=$(node-2.0.3.4-linux-amd64 --node-info | grep "Owned balance" | awk '{print $3, $4}')

# Проверяем, если файл balance.log существует и не пустой, извлекаем последнее значение баланса
if [[ -s balance.log ]]; then
    last_logged_balance=$(tail -n 1 balance.log | awk '{print $5, $6}')
else
    last_logged_balance=""
fi

# Сравниваем текущее значение с последним записанным значением
if [[ "$current_balance" != "$last_logged_balance" ]]; then
    # Если значения отличаются, добавляем новую запись с датой
    echo "$(date '+%Y-%m-%d %H:%M:%S') Owned balance: $current_balance" >> balance.log
    echo "Запись добавлена в balance.log"
else
    echo "Баланс не изменился, запись не добавлена"
fi

EOF

# Даем права на выполнение скрипта
chmod +x "$SCRIPT_PATH"

# Строка для задания cron
CRON_JOB="*/5 * * * * $SCRIPT_PATH"

# Проверка и добавление в crontab пользователя
if ! crontab -l 2>/dev/null | grep -Fq "$CRON_JOB"; then
    # Добавляем новую строку к существующему crontab
    (crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -
    echo "Добавлено в crontab пользователя"
else
    echo "Запись уже существует в crontab пользователя"
fi

# Проверка и добавление в /hive/etc/crontab.root
if ! grep -Fq "$CRON_JOB" /hive/etc/crontab.root 2>/dev/null; then
    echo "$CRON_JOB" >> /hive/etc/crontab.root
    echo "Добавлено в /hive/etc/crontab.root"
else
    echo "Запись уже существует в /hive/etc/crontab.root"
fi
