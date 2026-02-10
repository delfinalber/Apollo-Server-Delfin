# WordPress local (Docker Compose)

Este proyecto levanta un blog WordPress local usando Docker Compose.

Pasos rápidos:

1. Copia y actualiza `.env` si quieres cambiar credenciales (o usa `.env.example`).
2. Generar certificado self-signed para desarrollo (opcional):

```bash
cd nginx
sh generate-self-signed.sh
cd ..
```

3. Levanta los servicios:

```bash
docker compose up -d
```

4. Accede a WordPress en https://localhost
5. phpMyAdmin en https://localhost/phpmyadmin (usa credenciales de `.env`)

Despliegue con Ansible (ejemplo):

1. Edita `ansible/inventory.ini` con el host real.
2. Ejecuta desde la carpeta `ansible`:

```bash
ansible-playbook -i inventory.ini playbook.yml
```

Notas:
- La carpeta `certs/` está en `.gitignore`. No subir certificados privados.
- Cambia las contraseñas por defecto en `.env` antes de usar en producción.
# WordPress local (Docker Compose)

Este proyecto levanta un blog WordPress local usando Docker Compose.

Pasos rápidos:

1. Copia y actualiza `.env` si quieres cambiar credenciales.
2. Levanta los servicios:

```bash
docker compose up -d
```

3. Accede a WordPress en http://localhost:8000
4. phpMyAdmin en http://localhost:8080 (usuario/contraseña desde `.env`)

Persistencia:
- La base de datos se guarda en el volumen `db_data`.
- Los archivos de WordPress se guardan en `wp_data`.

Notas:
- Cambia las contraseñas por defecto en `.env` antes de usar en red pública.
- Si usas Windows y Docker Desktop, usa `docker compose` o `docker-compose` según tu instalación.
