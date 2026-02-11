#!/bin/bash
set -e

cd /home/ubuntu/Apollo-Deploy/wordpress-blog

echo "=== Deteniendo contenedores actuales ==="
sudo docker-compose down 2>/dev/null || true

echo "=== Actualizando docker-compose.yml con APM ==="
cat > docker-compose.yml << 'DOCKER_EOF'
version: '3.8'
services:
  # APM Server - Monitoreo de rendimiento
  apm-server:
    image: docker.elastic.co/apm/apm-server:8.10.0
    restart: always
    command: apm-server -e -E apm-server.rum.enabled=true -E apm-server.rum.allow_origins=* -E apm-server.rum.allow_headers=*
    environment:
      ELASTICSEARCH_HOSTS: http://elasticsearch:9200
      KIBANA_HOSTS: http://kibana:5601
    ports:
      - "8200:8200"
    networks:
      - webnet
    depends_on:
      - elasticsearch

  # Elasticsearch - Base de datos para APM
  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:8.10.0
    restart: always
    environment:
      - discovery.type=single-node
      - xpack.security.enabled=false
      - "ES_JAVA_OPTS=-Xms512m -Xmx512m"
    ports:
      - "9200:9200"
    volumes:
      - elasticsearch_data:/usr/share/elasticsearch/data
    networks:
      - webnet

  # Kibana - Visualización del APM
  kibana:
    image: docker.elastic.co/kibana/kibana:8.10.0
    restart: always
    environment:
      ELASTICSEARCH_HOSTS: http://elasticsearch:9200
      ELASTICSEARCH_USERNAME: elastic
      ELASTICSEARCH_PASSWORD: ""
    ports:
      - "5601:5601"
    networks:
      - webnet
    depends_on:
      - elasticsearch

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
  elasticsearch_data:

networks:
  webnet:
    driver: bridge
DOCKER_EOF

echo "=== Levantando contenedores con APM ==="
sudo docker-compose up -d

echo "=== Esperando que los servicios se levanten (30s) ==="
sleep 30

echo "=== Estado de contenedores ==="
sudo docker-compose ps

echo ""
echo "=========================================="
echo "✅ APM INSTALADO EXITOSAMENTE"
echo "=========================================="
echo ""
echo "Acceso a los servicios:"
echo "  • WordPress: http://98.94.9.28"
echo "  • phpMyAdmin: http://98.94.9.28:8080"
echo "  • Kibana (APM Dashboard): http://98.94.9.28:5601"
echo "  • APM Server: http://98.94.9.28:8200"
echo ""
