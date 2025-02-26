# Используем официальный образ Python (не slim)
FROM python:3.10

# Устанавливаем переменные окружения
ENV PYTHONUNBUFFERED=1
ENV PYTHONPATH=/app

# Устанавливаем рабочую директорию
WORKDIR /app

# Устанавливаем системные зависимости (если нужно)
RUN apt-get update && apt-get install -y \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Копируем и устанавливаем Python-зависимости
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Копируем весь проект
COPY . .

# Команда по умолчанию (для Django)
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "FILTER.wsgi:application"]

