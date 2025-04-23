#!/bin/bash
set -e

# Создаем директории для статики и медиа, если они не существуют
mkdir -p /app/static /app/media

# Устанавливаем правильные права доступа
chmod -R 755 /app/static /app/media

# Подождать, пока база данных будет готова
echo "Waiting for database..."
sleep 5

# Применить миграции
echo "Applying migrations..."
python manage.py migrate

# Собрать статические файлы
echo "Collecting static files..."
python manage.py collectstatic --noinput

# Запустить команду из docker-compose
exec "$@"
