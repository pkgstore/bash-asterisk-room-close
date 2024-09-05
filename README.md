# Asterisk: Room Close

Скрипт закрытия конференц-комнаты Asterisk при условии, что в ней остаётся 1 пользователь с определённым номером телефона.

## Установка

- Скопировать файлы `app.asterisk.room-close.ini` и `app.asterisk.room-close.sh` в директорию `/root/apps/`.
- Скопировать файл `app_asterisk_room-close` в директорию `/etc/cron.d/`.
- Настроить параметры скрипта в файле `app.asterisk.room-close.ini`.
