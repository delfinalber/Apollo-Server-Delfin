#!/usr/bin/env bash
set -euo pipefail

# deploy.sh - Actualiza repo, levanta stack y hace healthcheck con rollback
# Uso: ./deploy.sh [project_dir]

PROJECT_DIR="${1:-$(pwd)}"
HEALTH_URL="${HEALTH_URL:-https://localhost/}"
RETRIES=${RETRIES:-10}
SLEEP=${SLEEP:-4}

echo "Proyecto: $PROJECT_DIR"
cd "$PROJECT_DIR"

if ! git rev-parse --git-dir >/dev/null 2>&1; then
  echo "No es un repo git en $PROJECT_DIR"
  exit 1
fi

PREV_COMMIT=$(git rev-parse --short HEAD || true)
echo "Commit actual: $PREV_COMMIT"

echo "Obteniendo cambios del remoto..."
git fetch origin
git reset --hard origin/main

if [ ! -f .env ] && [ -f .env.example ]; then
  echo "Copiando .env desde .env.example"
  cp .env.example .env
fi

echo "Actualizando imágenes y levantando contenedores..."
docker compose pull || true
docker compose up -d --remove-orphans

echo "Esperando servicios y realizando healthcheck en: $HEALTH_URL"
success=0
for i in $(seq 1 $RETRIES); do
  if curl -k --fail --max-time 5 "$HEALTH_URL" >/dev/null 2>&1; then
    echo "Healthcheck OK (intento $i)"
    success=1
    break
  else
    echo "Healthcheck fallo (intento $i/$RETRIES). Esperando $SLEEP s..."
    sleep $SLEEP
  fi
done

if [ "$success" -eq 1 ]; then
  echo "Despliegue completado correctamente."
  exit 0
fi

echo "Healthcheck falló tras $RETRIES intentos." >&2
if [ -n "$PREV_COMMIT" ]; then
  echo "Intentando rollback a $PREV_COMMIT"
  git reset --hard "$PREV_COMMIT"
  docker compose up -d --remove-orphans
  echo "Rollback ejecutado. Espera y comprueba manualmente." >&2
  exit 1
else
  echo "No hay commit anterior conocido; no se puede hacer rollback." >&2
  exit 2
fi
