# Stage 1 — base
FROM python:3.12-slim

WORKDIR /app

# Установим зависимости
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Копируем весь проект
COPY . .

# Добавим пользователя
RUN adduser --disabled-password appuser
USER appuser

# Запуск Gunicorn
CMD ["gunicorn", "config.wsgi:application", "--bind", "0.0.0.0:8000"]
