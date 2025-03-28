# Use the official Ubuntu image from Docker Hub as the base image
FROM  python:3.13-slim


# Update the package list and install essential packages
RUN apt-get update && apt-get install -y \
    supervisor \
    systemctl \
    curl \
    vim \
    git \
    build-essential \
    python3 \
    python3-pip \
    python3-venv \
    python3-dev \
    libxml2-dev \
    libxslt1-dev \
    libffi-dev \
    libpq-dev \
    libssl-dev \
    zlib1g-dev \
    && apt-get clean\
    mkdir temp

# Set the working directory inside the container
WORKDIR /opt

#ADDED FOR DEPLOYMENT TESTS
COPY ./opt /opt 

#Expose the application port (Gunicorn typically runs on 8001)
EXPOSE 8000
#add user
RUN adduser --system --group status-page


# RUN status-page/upgrade.sh