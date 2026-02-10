#!/usr/bin/env sh
set -e

CERT_DIR="./certs"
mkdir -p "$CERT_DIR"

CN=localhost
KEY="$CERT_DIR/localhost.key"
CRT="$CERT_DIR/localhost.crt"

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout "$KEY" -out "$CRT" \
  -subj "/C=US/ST=State/L=City/O=Local/CN=$CN"

echo "Self-signed certificate generated: $CRT and $KEY"
