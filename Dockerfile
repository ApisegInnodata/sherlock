# -----------------------------------------------------------------------------
# Build stage: create a venv with dependencies + install the project (non-editable)
# -----------------------------------------------------------------------------
FROM ghcr.io/astral-sh/uv:python3.12-bookworm-slim AS build
WORKDIR /app

# (Optional) Keep bytecode out + unbuffered logs
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Copy dependency files first for better layer caching
COPY pyproject.toml uv.lock ./

# Install only locked deps (no project yet)
RUN uv sync --frozen --no-dev --no-install-project

# Copy the rest of the application
COPY . .

# Install the project into the venv as a normal (non-editable) install
# IMPORTANT: this avoids imports pointing to /app source in runtime
RUN uv sync --frozen --no-dev --no-editable

# -----------------------------------------------------------------------------
# Runtime stage: slim python image + copy the built venv
# -----------------------------------------------------------------------------
FROM python:3.12-slim-bookworm
WORKDIR /app

ARG VCS_REF=""
ARG VCS_URL="https://github.com/sherlock-project/sherlock"
ARG VERSION_TAG=""

ENV SHERLOCK_ENV=docker \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PATH="/app/.venv/bin:$PATH"

LABEL org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url=$VCS_URL \
      org.label-schema.name="Sherlock" \
      org.label-schema.version=$VERSION_TAG \
      website="https://sherlockproject.xyz"

# Copy the virtual environment from the build stage
COPY --from=build /app/.venv /app/.venv

# If sherlock needs OS packages at runtime, add them here (example):
# RUN apt-get update && apt-get install -y --no-install-recommends <pkgs> \
#     && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["sherlock"]
