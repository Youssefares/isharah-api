#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /egsl-website-api/tmp/pids/server.pid

# Run mailcatcher daemon
mailcatcher --http-ip=0.0.0.0

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
