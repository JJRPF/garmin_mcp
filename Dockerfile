# Use Python 3.12 slim image for smaller size
FROM python:3.12-slim

# Note: .dockerignore is symlinked to .gitignore for unified exclusion rules

# Set working directory
WORKDIR /app

# Install uv for faster dependency management
# https://github.com/astral-sh/uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    UV_SYSTEM_PYTHON=1

# Copy dependency files and README first for better layer caching
COPY pyproject.toml README.md ./

# Copy the application source code (needed for editable install)
COPY src/ ./src/

# Install dependencies using uv
RUN uv pip install -e .

# Copy test files (optional, for testing in container)
COPY tests/ ./tests/
COPY pytest.ini ./

# Create directory for Garmin tokens
RUN mkdir -p /root/.garminconnect && \
    chmod 700 /root/.garminconnect

# Copy entrypoint script
COPY entrypoint.sh ./
RUN chmod +x entrypoint.sh

# Expose HTTP ports (7860 for Hugging Face Spaces, 8000 for standard)
EXPOSE 7860
EXPOSE 8000

# Set the entrypoint
ENTRYPOINT ["/app/entrypoint.sh"]

