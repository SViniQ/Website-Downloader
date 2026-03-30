#!/bin/bash
set -e

# Usa a variável de ambiente PORT, ou 8080 como padrão caso ela não exista
PORT="${PORT:-8080}"

echo "Starting gunicorn on port $PORT..."

exec gunicorn app:app \
    --bind "0.0.0.0:$PORT" \
    --workers 1 \
    --threads 2 \
    --timeout 300 \
    --worker-class gthread \
    --access-logfile - \
    --error-logfile -
    
