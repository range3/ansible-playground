FROM mcr.microsoft.com/devcontainers/base:noble

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

RUN export DEBIAN_FRONTEND=noninteractive \
    && apt update \
    && apt install -y --no-install-recommends \
      python3 \
      python3-venv \
      python3-pip

# Install Docker CLI
RUN export DEBIAN_FRONTEND=noninteractive \
    && apt update \
    && apt install -y --no-install-recommends \
      curl \
      ca-certificates \
    && install -m 0755 -d /etc/apt/keyrings \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc \
    && chmod a+r /etc/apt/keyrings/docker.asc \
    && echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" \
        | tee /etc/apt/sources.list.d/docker.list \
    && apt update \
    && apt install -y --no-install-recommends \
      docker-ce-cli \
      docker-buildx-plugin \
      docker-compose-plugin

RUN if ! grep -qE '^docker:' /etc/group; then \
        groupadd --system docker; \
    fi \
    && usermod -aG docker vscode

# Create docker-init script for dynamic GID adjustment
COPY docker-init.sh /usr/local/bin/docker-init.sh
RUN chmod +x /usr/local/bin/docker-init.sh

ENTRYPOINT ["/usr/local/bin/docker-init.sh"]
