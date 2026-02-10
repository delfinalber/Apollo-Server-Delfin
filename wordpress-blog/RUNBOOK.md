# RUNBOOK — Despliegue rápido WordPress

Resumen rápido:

- Requisitos: Docker y Docker Compose instalados en el host remoto. Usuario con sudo y acceso SSH.
- Ruta recomendada en servidor: `/opt/wordpress-blog` (variable `PROJECT_DIR`).

Variables importantes:

- `PROJECT_DIR=/opt/wordpress-blog`
- `.env` — credenciales; usar `.env.example` como plantilla.
- Puertos públicos: `80` y `443` (Nginx delante de WordPress).

Despliegue manual (copiar/pegar en el servidor Linux):

```bash
# Preparar directorio
sudo mkdir -p /opt/wordpress-blog
sudo chown $USER:$USER /opt/wordpress-blog
cd /opt/wordpress-blog

# Clonar o actualizar repo
git clone https://github.com/<tu-org>/laboratorio-herramientas-automatizacion-despliegue.git .
# o si ya existe
# git pull origin main

# Copiar .env si no existe y editar
cp .env.example .env
# Edita .env con contraseñas seguras
nano .env

# Generar certificado self-signed (solo desarrollo)
cd nginx
sh generate-self-signed.sh
cd ..

# Levantar stack
docker compose up -d

# Comprobaciones básicas
sleep 8
docker compose ps
curl -k --head https://localhost/ | head -n 1
curl -k --head https://localhost/phpmyadmin/ | head -n 1
```

Actualizar (sin borrar volúmenes):

```bash
cd /opt/wordpress-blog
git fetch origin
git reset --hard origin/main
docker compose pull
docker compose up -d --remove-orphans
```

Rollback (usar commits o tags):

```bash
cd /opt/wordpress-blog
git checkout <commit-or-tag-anterior>
docker compose up -d
```

Backup de la base de datos antes de cambios importantes:

```bash
docker compose exec -T db sh -c 'exec mysqldump -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE"' > /tmp/wp_backup.sql
```

Healthcheck básico (`healthcheck.sh`):

```bash
#!/usr/bin/env bash
set -e
HOST=https://localhost
if curl -k --fail "$HOST" >/dev/null; then
  echo "OK"
  exit 0
else
  echo "FAIL"
  exit 2
fi
```

Despliegue con Ansible (ejemplo):

```bash
cd ansible
# editar inventory.ini con el host real
ansible-playbook -i inventory.ini playbook.yml
```

CI/CD (sugerencia): usar GitHub Actions con rsync sobre SSH para sincronizar al host y luego ejecutar `docker compose up -d`.

Notas:

- No subir `certs/` al repositorio (está en `.gitignore`).
- Reemplaza las contraseñas de ejemplo por valores seguros.
- Si necesitas integración con un load balancer/letsencrypt, modifica Nginx y añade renovación automática.
