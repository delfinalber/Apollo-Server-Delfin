cat > install-apm-lite.sh << 'EOF'
#!/bin/bash
set -e

cd /home/ubuntu/Apollo-Deploy/wordpress-blog

echo "=== Actualizando docker-compose.yml con APM (sin phpMyAdmin) ==="
cat > docker-compose.yml << 'DOCKER_EOF'
version: '3.8'
services:
  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:8.12.0
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

  apm-server:
    image: docker.elastic.co/apm/apm-server:8.12.0
    restart: always
    command: apm-server -e -E apm-server.rum.enabled=true
    environment:
      ELASTICSEARCH_HOSTS: http://elasticsearch:9200
    ports:
      - "8200:8200"
    networks:
      - webnet
    depends_on:
      - elasticsearch

  kibana:
    image: docker.elastic.co/kibana/kibana:8.12.0
    restart: always
    environment:
      ELASTICSEARCH_HOSTS: http://elasticsearch:9200
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

echo "=== Levantando contenedores ==="
sudo docker-compose up -d

echo "=== Esperando 60s ==="
sleep 60

sudo docker-compose ps

echo ""
echo "=========================================="
echo "✅ APM INSTALADO (sin phpMyAdmin)"
echo "=========================================="
echo ""
echo "Servicios disponibles:"
echo "  • WordPress: http://98.94.9.28"
echo "  • Kibana (APM): http://98.94.9.28:5601"
echo "  • APM Server: http://98.94.9.28:8200"
echo ""
echo "Nota: phpMyAdmin NO está instalado por espacio"
echo ""
EOF

chmod +x install-apm-lite.sh
./install-apm-lite.sh