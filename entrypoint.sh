#!/usr/bin/env bash
set -e

echo "Collecting static files..."
python3 manage.py collectstatic --noinput

echo "Making migrations..."
python3 manage.py makemigrations

echo "Applying migrations..."
python3 manage.py migrate

echo "Creating superuser..."
python3 manage.py createsuperuser 

echo "Starting Gunicorn WSGI server..."
exec gunicorn truck_signs_designs.wsgi:application --bind 0.0.0.0:8000