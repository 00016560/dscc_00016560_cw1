# Stage 1 — base
FROM python:3.12-slim

WORKDIR /app

RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the entire project
COPY . .

# Create user and set permissions in one layer
RUN adduser --disabled-password --gecos '' appuser && \
    mkdir -p /app/staticfiles /app/media && \
    chown -R appuser:appuser /app && \
    chmod -R 755 /app

# Collect static files during build (still as root in this layer)
RUN python manage.py collectstatic --noinput

# Ensure collected static files have correct ownership
RUN chown -R appuser:appuser /app/staticfiles /app/media

# Switch to non-root user
USER appuser

# Run Gunicorn
CMD ["gunicorn", "config.wsgi:application", "--bind", "0.0.0.0:8000"]