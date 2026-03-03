# Stage 1 — base
FROM python:3.12-slim

WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the entire project
COPY . .

# Create directory for static files and set permissions
RUN mkdir -p /app/staticfiles /app/media && \
    chown -R appuser:appuser /app && \
    chmod -R 755 /app

# Add user
RUN adduser --disabled-password --gecos '' appuser

# Collect static files during build (as root)
RUN python manage.py collectstatic --noinput

# Change ownership after collecting static files
RUN chown -R appuser:appuser /app/staticfiles /app/media

# Switch to non-root user
USER appuser

# Run Gunicorn
CMD ["gunicorn", "config.wsgi:application", "--bind", "0.0.0.0:8000"]