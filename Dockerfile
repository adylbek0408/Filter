# Используем официальный образ Python (не slim)
FROM python:3.10

# Устанавливаем переменные окружения
ENV PYTHONUNBUFFERED=1
ENV PYTHONPATH=/app
ENV DJANGO_SETTINGS_MODULE=FILTER.settings

# Установка локали
RUN apt-get update && apt-get install -y \
    libpq-dev \
    gettext \
    locales \
    && rm -rf /var/lib/apt/lists/* \
    && sed -i -e 's/# ru_RU.UTF-8 UTF-8/ru_RU.UTF-8 UTF-8/' /etc/locale.gen \
    && locale-gen

ENV LANG ru_RU.UTF-8
ENV LANGUAGE ru_RU:ru
ENV LC_ALL ru_RU.UTF-8

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем и устанавливаем Python-зависимости
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Копируем весь проект
COPY . .

# Создаём и компилируем файлы локализации для русского языка (если их нет)
RUN mkdir -p locale/ru/LC_MESSAGES
RUN django-admin compilemessages -l ru || echo "No message files found, skipping compilemessages"

# Команда по умолчанию (для Django)
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "FILTER.wsgi:application"]

