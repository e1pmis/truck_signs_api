# Truck Sign Shop – Dockerized Setup

This guide explains how to containerize the Truck Sign Shop application and run it alongside a PostgreSQL database using Docker only.

Each service runs in its own container, and communication is handled via the main Docker network.

---

## Table of Contents

1. [Prerequisites](#prerequisites)  
2. [Quickstart](#quickstart)  
3. [Usage](#usage)  
   - 3.1 [Creating a Django Superuser](#31-creating-a-django-superuser)  
   - 3.2 [Logging into Django Admin and Managing Products](#32-logging-into-django-admin-and-managing-products)
   - 3.3 [External Deployment](#33-external-deployment)


---

## Prerequisites

### Software

- **Docker**  
  ```bash
  sudo apt update
  sudo apt install -y docker postgresql
    ```
- **postgresql**  
  ```bash
  sudo apt install -y postgresql
    ```
  
## Quickstart 

### 1. Create PostgreSQL user and database on your local machine

```bash
sudo -i -u postgres
psql
```
Inside psql, run:

```bash
CREATE USER trucksigns_user WITH PASSWORD '<YOUR_DB_PASSWORD>';
CREATE DATABASE trucksigns_db OWNER trucksigns_user;
GRANT ALL PRIVILEGES ON DATABASE trucksigns_db TO trucksigns_user;
\q
exit
```
### 2. Start PostgreSQL Container

```bash
docker run -d \
  --name trucksigns_db \
  -e POSTGRES_USER=trucksigns_user \
  -e POSTGRES_PASSWORD=<YOUR_DB_PASSWORD> \
  -e POSTGRES_DB=trucksigns_db \
  -p 5433:5432 \
  postgres:15
```
This exposes PostgreSQL on port 5433 of the host machine.

### 3. Build the Application Image

```bash
docker build -t trucksigns_app:latest .
```
### 4. Run the Application Container

```bash
docker run -it  --restart=on-failure -p 8020:8000 trucksigns_app:latest
```

After Step 4,the Truck Sign Shop application will be running inside a Docker container and accessible on the port 8020 of the host machine and the container will restart once an error accured.

## Usage

### 3.1 Django Superuser Creation on Container Start

Upon starting the Django application container, a prompt will appear requesting the following details for superuser creation:

* Username

* Email address

* Password

The container should be run as indicated in the Quickstart section, and the prompts in the container’s terminal should be followed to complete the admin user setup.

### 3.2 Logging into Django Admin and Managing Products

you can log in and start managing the shop.

1. Open your browser and go to:

```bash
http://localhost:8020/admin
```

2. Log in using the superuser credentials you just created.

3. In the Django admin dashboard, you can:

* Add Categories

* Add Products under specific categories

* Edit or delete existing items

### 3.3 External Deployment

To publish the server externally, you need to configure Django to allow requests from your external IP address or domain.

Open your [settings.py](settings.py) file and find the ALLOWED_HOSTS setting. Add your server's IP address or domain name:

```python
ALLOWED_HOSTS = ['your.server.ip.address', 'localhost']
```

