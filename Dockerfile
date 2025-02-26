# Базовый образ
FROM python:3.11-bullseye

# Установка рабочей директории
WORKDIR /app

# Установка переменных окружения
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    TZ=UTC

# Копирование зависимостей Python
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Копирование исходного кода проекта
COPY . .

# Создание директории для статических файлов
RUN mkdir -p /app/static

# Открытие порта для Django
EXPOSE 8000

# Скрипт запуска
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
