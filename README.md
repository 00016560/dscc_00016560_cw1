# DSCC Task Manager

## Описание
Приложение задач на Django с авторизацией, CRUD, PostgreSQL, Docker и Gunicorn.

## Запуск
1. Клонировать репозиторий
2. Создать .env с параметрами базы
3. `docker-compose up --build`
4. `docker-compose exec web python manage.py migrate`
5. Админка: http://localhost:8000/admin

## Требования
- Docker, Docker Compose
- Python 3.12
- PostgreSQL
