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
    netcat-openbsd \  # Add netcat for port checking
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory inside the container
WORKDIR /opt

# Copy necessary files
COPY ./opt /opt

# Add user
RUN adduser --system --group status-page

# Install wait-for-it script for dependency checking
RUN wget https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh -O /usr/local/bin/wait-for-it.sh \
    && chmod +x /usr/local/bin/wait-for-it.sh

# Set permissions
RUN chown -R status-page:status-page /opt

# Switch to status-page user
USER status-page

# Create and activate virtual environment
RUN python3 -m venv /opt/venv

# Activate virtual environment and install dependencies
RUN . /opt/venv/bin/activate && \
    pip install --no-cache-dir -r /opt/requirements.txt

# Expose ports
EXPOSE 8000 8001

# Entrypoint script to handle dependencies and startup
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Use entrypoint to manage dependencies and startup
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
