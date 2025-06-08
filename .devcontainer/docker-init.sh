#!/usr/bin/env bash
#-------------------------------------------------------------------------------------------------------------
# Simple Docker socket permission adjustment for DevContainers
#-------------------------------------------------------------------------------------------------------------
set -e

DOCKER_SOCKET="${DOCKER_SOCKET:-"/var/run/docker.sock"}"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

# Only proceed if socket exists
if [ ! -S "${DOCKER_SOCKET}" ]; then
    log "WARNING: Docker socket ${DOCKER_SOCKET} not found"
    exec "$@"
fi

# Get socket GID and current docker group GID
SOCKET_GID=$(stat -c '%g' "${DOCKER_SOCKET}")
DOCKER_GID=$(getent group docker | cut -d: -f3)

log "Docker socket GID: ${SOCKET_GID}, Container docker group GID: ${DOCKER_GID}"

# If GIDs don't match and socket is not owned by root, adjust docker group GID
if [ "${SOCKET_GID}" != "${DOCKER_GID}" ] && [ "${SOCKET_GID}" != "0" ]; then
    # Check if a group with the socket GID already exists
    if ! getent group "${SOCKET_GID}" > /dev/null 2>&1; then
        log "Updating docker group GID to ${SOCKET_GID}"
        groupmod --gid "${SOCKET_GID}" docker
        log "Successfully updated docker group GID"
    else
        log "Group with GID ${SOCKET_GID} already exists, skipping GID change"
    fi
else
    log "Docker group GID already matches socket or socket is owned by root"
fi

log "Docker setup completed"

# Execute the main command
exec "$@"
