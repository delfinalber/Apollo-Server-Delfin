#!/bin/bash
set -e

cd /home/ubuntu/Apollo-Deploy/wordpress-blog

echo "=== Deteniendo contenedores ==="
sudo docker-compose down

echo "=== Actualizando docker-compose.yml ==="
cat > docker-compose.yml << 'DOCKER_EOF'
version: '3.8'
services:
  db:
    image: mariadb:10.8
    restart: always
    env_file: .env
    environment:
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
      MYSQL_DATABASE: ${MYSQL_DATABASE}
      MYSQL_USER: ${MYSQL_USER}
      MYSQL_PASSWORD: ${MYSQL_PASSWORD}
    volumes:
      - db_data:/var/lib/mysql
    networks:
      - webnet

  wordpress:
    image: wordpress:6.3-php8.1-apache
    depends_on:
      - db
    env_file: .env
    environment:
      WORDPRESS_DB_HOST: db:3306
      WORDPRESS_DB_USER: ${MYSQL_USER}
      WORDPRESS_DB_PASSWORD: ${MYSQL_PASSWORD}
      WORDPRESS_DB_NAME: ${MYSQL_DATABASE}
    volumes:
      - ./wp_data:/var/www/html
    networks:
      - webnet

  phpmyadmin:
    image: phpmyadmin:latest
    depends_on:
      - db
    environment:
      PMA_HOST: db
      PMA_USER: ${MYSQL_USER}
      PMA_PASSWORD: ${MYSQL_PASSWORD}
    ports:
      - "8080:80"
    networks:
      - webnet

  nginx:
    image: nginx:stable-alpine
    restart: always
    depends_on:
      - wordpress
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx/conf.d:/etc/nginx/conf.d:ro
      - ./certs:/etc/nginx/certs:ro
    networks:
      - webnet

volumes:
  db_data:

networks:
  webnet:
    driver: bridge
DOCKER_EOF

echo "=== Levantando contenedores ==="
sudo docker-compose up -d

echo "=== Esperando que los servicios se levanten ==="
sleep 10

echo "=== Estado de contenedores ==="
sudo docker-compose ps

echo "=== Listo! ==="
