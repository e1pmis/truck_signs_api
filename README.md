# Truck Sign Shop – Dockerized Setup

This guide explains how to containerize the Truck Sign Shop application and run it alongside a PostgreSQL database using Docker only.

Each service runs in its own container, and communication is handled via the main Docker network.

---

## Table of Contents

1. [Prerequisites](#prerequisites)  
2. [Quickstart](#quickstart)  
3. [Usage](#usage)  
   - 3.1 [Generating a Django SECRET_KEY](#31-generating-a-django-secret_key)  
   - 3.2 [Creating a Django Superuser](#32-creating-a-django-superuser)  
   - 3.3 [Logging into Django Admin and Managing Products](#33-logging-into-django-admin-and-managing-products)
   - 3.4 [External Deployment](#34-external-deployment)


---

## Prerequisites

### Software

- **Docker**  
  ```bash
  sudo apt update
  sudo apt install -y docker 
    ```

## Quickstart 

### 1. Clone the Repository and Enter the Project Directory

Start by cloning the project repository and enter the main directory: 

```bash
git clone https://github.com/e1pmiS/truck_signs_api.git
cd truck_signs_api
```

### 2. Set Up Environment Variables

The project uses environment variables for configuration. A sample file simple_env_config.env is provided. Copy the sample file to create your own .env file:

```bash
cp truck_signs_designs/settings/simple_env_config.env truck_signs_designs/settings/.env
```
then open the .env file and update any variables as needed, such as database credentials or your Django SECRET_KEY.

💡 If you don’t have a SECRET_KEY, see section [3.1 Generating a Django SECRET_KEY](#31-generating-a-django-secret_key) for instructions on how to create one securely.

### 3. Network configutration

In this setup, the database host should be set to the Docker host IP address 172.17.0.1. This IP belongs to the default Docker bridge network interface (docker0) and is accessible from containers by default.

On Linux, Docker automatically creates the docker0 network when you install Docker. You do not need to create it manually.

If you run your containers on the default bridge network, your Django container can reach services running on the host (like PostgreSQL) via 172.17.0.1.

### 4. Start PostgreSQL Container

```bash
docker run -d \
  --name trucksigns_db \
  --network ts_net \
  --env-file truck_signs_designs/settings/.env \
  -p 5433:5432 \
  postgres:15
```
This exposes PostgreSQL on port 5433 of the host machine.

### 5. Build the Application Image

```bash
docker build -t trucksigns_app:latest .
```
### 6. Run the Application Container

```bash
docker run -it --network ts_net --restart=on-failure -p 8020:8000 trucksigns_app:latest
```

After Step 4,the Truck Sign Shop application will be running inside a Docker container and accessible on the port 8020 of the host machine and the container will restart once an error accured.



## Usage

### 3.1 Generating a Django SECRET_KEY

A secure SECRET_KEY is essential for the security of your Django application. You can generate one using Python directly from your terminal.

Run the following command:

```bash
python -c 'from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())'
```

This will output a secure, random string you can use as your SECRET_KEY.

### 3.2 Django Superuser Creation on Container Start

Upon starting the Django application container, a prompt will appear requesting the following details for superuser creation:

* Username

* Email address

* Password

The container should be run as indicated in the Quickstart section, and the prompts in the container’s terminal should be followed to complete the admin user setup.

### 3.3 Logging into Django Admin and Managing Products

you can log in and start managing the shop.

1. Open your browser and go to:

```bash
http://<your_ip>:8020/admin
```

2. Log in using the superuser credentials you just created.

3. In the Django admin dashboard, you can:

* Add Categories

* Add Products under specific categories

* Edit or delete existing items

### 3.4 External Deployment

To publish the server externally, you need to configure Django to allow requests from your external IP address or domain.

Open your [base.py](truck_signs_designs/settings/base.py) file and find the ALLOWED_HOSTS setting. Add your server's IP address or domain name:

```python
ALLOWED_HOSTS = [<your_server_ip_address>, 'localhost']
```

