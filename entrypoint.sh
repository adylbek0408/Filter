#!/bin/bash
set -e

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
