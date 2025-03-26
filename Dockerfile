FROM python:3.13-slim

# Install system dependencies
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
    netcat-openbsd \
    wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Copy the entire project
COPY . /app

# Copy requirements file from the specified location
COPY /opt/requirements.txt /app/requirements.txt

# Create virtual environment
RUN python3 -m venv /app/venv

# Activate virtual environment and install dependencies
RUN . /app/venv/bin/activate && \
    pip install --upgrade pip && \
    pip install gunicorn && \
    pip install -r /app/requirements.txt

# Install wait-for-it script
RUN wget https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh -O /usr/local/bin/wait-for-it.sh \
    && chmod +x /usr/local/bin/wait-for-it.sh

# Make upgrade script executable
RUN if [ -f /app/upgrade.sh ]; then chmod +x /app/upgrade.sh; fi

# Expose ports
EXPOSE 8000 8001

# Copy and make entrypoint executable
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Use entrypoint to manage dependencies and startup
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
