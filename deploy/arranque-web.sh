#!/bin/sh
# Arranque del contenedor web de EXPANSIONdeDOMINIO.
# Se ejecuta desde la carpeta del repositorio descargado (ver docker-compose.yml).
set -e
REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"

rm -rf /usr/share/nginx/html/*
cp -r "$REPO_DIR/site/." /usr/share/nginx/html/
cp "$REPO_DIR/deploy/nginx.conf" /etc/nginx/conf.d/default.conf

# Usuario y contraseña del panel /estadisticas/ (la contraseña viene de Hostinger)
if [ -n "$STATS_PASS" ]; then
  printf 'admin:%s\n' "$(cryptpw -m sha512 "$STATS_PASS")" > /etc/nginx/stats.htpasswd
else
  : > /etc/nginx/stats.htpasswd
fi

mkdir -p /var/log/nginx-stats
touch /var/log/nginx-stats/access.log
echo "Web EXPANSIONdeDOMINIO publicada"
exec nginx -g 'daemon off;'
