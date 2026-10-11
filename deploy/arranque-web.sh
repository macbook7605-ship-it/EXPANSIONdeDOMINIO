#!/bin/sh
# Arranque del contenedor web de EXPANSIONdeDOMINIO.
# Se ejecuta desde la carpeta del repositorio descargado (ver docker-compose.yml).
set -e
REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"

rm -rf /usr/share/nginx/html/*
cp -r "$REPO_DIR/site/." /usr/share/nginx/html/
cp "$REPO_DIR/deploy/nginx.conf" /etc/nginx/conf.d/default.conf

# Red de seguridad: si la configuración tiene errores, se usa una versión básica
mkdir -p /var/log/nginx-stats && touch /var/log/nginx-stats/access.log && : > /etc/nginx/stats.htpasswd
if ! nginx -t >/dev/null 2>&1; then
  echo "AVISO: nginx.conf con errores; se usa la configuración básica"
  nginx -t 2>&1 | tail -3
  sed -i '/sub_filter/d; /^map /,/^}/d' /etc/nginx/conf.d/default.conf
fi

# Usuario y contraseña del panel /estadisticas/ (la contraseña viene de Hostinger)
if [ -n "$STATS_PASS" ]; then
  printf 'admin:%s\n' "$(cryptpw -m sha512 "$STATS_PASS")" > /etc/nginx/stats.htpasswd
else
  : > /etc/nginx/stats.htpasswd
fi

mkdir -p /var/log/nginx-stats
touch /var/log/nginx-stats/access.log
# Estadísticas: GoAccess regenera el informe cada 5 minutos en segundo plano
mkdir -p /usr/share/nginx/stats
if apk add --no-cache goaccess >/dev/null 2>&1; then
  ( while true; do
      goaccess /var/log/nginx-stats/access.log --log-format=COMBINED \
        --html-report-title="EXPANSIONdeDOMINIO" -o /usr/share/nginx/stats/index.html >/dev/null 2>&1
      sleep 300
    done ) &
  echo "Estadísticas activadas"
else
  echo "No se pudo instalar GoAccess; la web funciona igual"
fi

echo "Web EXPANSIONdeDOMINIO publicada"
exec nginx -g 'daemon off;'
