# Use a lightweight Python base image
FROM python:3.12-slim

# Avoid interactive prompts and enable Python best practices
ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

# Create a non-root user for security
RUN useradd -m appuser

# Set working directory
WORKDIR /app

# Install system dependencies if needed (add more as required)
RUN apt-get update && \
    apt-get install -y --no-install-recommends build-essential && \
    rm -rf /var/lib/apt/lists/*

# Copy dependency file first (to leverage Docker layer caching)
COPY requirements.txt .

# Install Python dependencies
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

# Copy application source files
COPY src/ /app/src/

# Switch to non-root user
USER appuser

# Default command — can be overridden in docker-compose
CMD ["python", "src/main.py"]