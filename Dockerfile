# Use official Python 3.10-slim image
FROM python:3.10-slim

# Environment settings
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set work directory
WORKDIR /truck_signs_api

# Install system dependencies required for building and running the application
RUN apt-get update \
    && apt-get install -y libpq-dev gcc python3-dev libffi-dev libjpeg-dev zlib1g-dev libpng-dev libfreetype6-dev  netcat-openbsd

# Install Python dependencies
COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt

# Copy project files
COPY . ${WORKDIR}

# Expose Django dev server port
EXPOSE 8000

# Run migrations and then start the development server
CMD ./entrypoint.sh