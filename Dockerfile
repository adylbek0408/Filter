FROM python:3.10-alpine

# Устанавливаем переменные окружения
ENV PYTHONUNBUFFERED=1 \
    PYTHONPATH=/app \
    DJANGO_SETTINGS_MODULE=FILTER.settings \
    LANG=ru_RU.UTF-8 \
    LANGUAGE=ru_RU:ru \
    LC_ALL=ru_RU.UTF-8

# Установка необходимых пакетов и настройка локали в Alpine
RUN apk add --no-cache \
    postgresql-dev \
    gcc \
    musl-dev \
    gettext \
    tzdata \
    && cp /usr/share/zoneinfo/Asia/Bishkek /etc/localtime \
    && echo "Asia/Bishkek" > /etc/timezone

# Устанавливаем рабочую директорию
WORKDIR /app

# Создаем директории для статики и медиа
RUN mkdir -p /app/static /app/media && chmod -R 755 /app/static /app/media

# Копируем и устанавливаем Python-зависимости
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Копируем весь проект
COPY . .

# Создаём и компилируем файлы локализации для русского языка
RUN mkdir -p locale/ru/LC_MESSAGES \
    && python manage.py makemessages -l ru \
    && python manage.py compilemessages -l ru

# Команда по умолчанию (для Django)
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "FILTER.wsgi:application"]
