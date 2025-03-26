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

# Set the working directory inside the container
WORKDIR /opt

# Copy necessary files early
COPY ./opt /opt
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# Set permissions and ensure directories exist
RUN chmod +x /usr/local/bin/entrypoint.sh \
    && mkdir -p /opt/venv \
    && chmod -R 777 /opt

# Create virtual environment as root
RUN python3 -m venv /opt/venv

# Activate virtual environment and install dependencies
RUN . /opt/venv/bin/activate && \
    pip install --upgrade pip && \
    pip install gunicorn && \
    pip install -r /opt/requirements.txt

# Install wait-for-it script
RUN wget https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh -O /usr/local/bin/wait-for-it.sh \
    && chmod +x /usr/local/bin/wait-for-it.sh

# Expose ports
EXPOSE 8000 8001

# Use entrypoint to manage dependencies and startup
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
