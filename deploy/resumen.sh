#!/bin/sh
# Resumen sencillo de descargas, clics en "Comprar" y visitas al test, día por día.
# Lee los registros de nginx y escribe /usr/share/nginx/stats/descargas.html
# (protegido con la misma contraseña que /estadisticas/).
# Cuenta personas únicas por día (misma IP y mismo navegador = una persona) y descarta robots.
L=/var/log/nginx-stats
OUT=/usr/share/nginx/stats/descargas.html

cat $(ls -1 "$L"/access-*.log 2>/dev/null) "$L/access.log" 2>/dev/null | awk -v ahora="$(date '+%d/%m/%Y %H:%M')" '
BEGIN {
  split("Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec", m, " ")
  for (k = 1; k <= 12; k++) mes[m[k]] = sprintf("%02d", k)
}
{
  n = split($0, q, "\"")
  if (n < 6) next
  ua = q[6]
  if (tolower(ua) ~ /bot|spider|crawl|slurp|facebookexternalhit|whatsapp|preview|curl|wget|python|headless|scan|monitor/) next
  split(q[2], r, " "); met = r[1]; ruta = r[2]; sub(/\?.*/, "", ruta)
  split(q[3], s, " "); st = s[1]
  d = substr($4, 2, 11)                       # 20/Oct/2026
  dia = substr(d, 8, 4) "-" mes[substr(d, 4, 3)] "-" substr(d, 1, 2)
  quien = $1 "|" ua
  if (met != "GET" && met != "POST") next
  if (ruta ~ /version-gratuita\.pdf$/ && (st == 200 || st == 206)) cuenta("pdf", dia, quien)
  else if (ruta == "/habitos-emocionales/comprar" && st == 302) cuenta("buy", dia, quien)
  else if ((ruta == "/test/" || ruta == "/test") && st == 200) cuenta("test", dia, quien)
  if (st == 200 && (ruta ~ /\/$/ || ruta ~ /\.html$/)) cuenta("vis", dia, quien)
}
function cuenta(tipo, dia, quien) {
  k = tipo "|" dia "|" quien
  if (!(k in visto)) { visto[k] = 1; c[tipo "|" dia]++; tot[tipo]++; dias[dia] = 1 }
}
END {
  print "<!doctype html><html lang=\"es\"><head><meta charset=\"utf-8\"><meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">"
  print "<title>Descargas y ventas · EXPANSIONdeDOMINIO</title><style>"
  print "body{background:#141210;color:#efe7dc;font-family:Arial,sans-serif;margin:0;padding:24px 16px}main{max-width:720px;margin:0 auto}"
  print "h1{font-family:Georgia,serif;color:#f6efe4;font-size:28px;margin:0 0 4px}p{color:#8a8073;font-size:13px;margin:0 0 24px}"
  print ".tot{display:grid;grid-template-columns:repeat(2,1fr);gap:10px;margin-bottom:28px}.tot div{border:1px solid #2f2a24;padding:14px}"
  print ".tot b{display:block;font-size:30px;color:#C9A45C}.tot span{font-size:12px;letter-spacing:.1em;text-transform:uppercase;color:#cfc5b7}"
  print "table{width:100%;border-collapse:collapse;font-size:15px}th,td{padding:10px 6px;border-bottom:1px solid #2f2a24;text-align:right}"
  print "th{font-size:11px;letter-spacing:.12em;text-transform:uppercase;color:#C9A45C}th:first-child,td:first-child{text-align:left}"
  print "a{color:#C9A45C}</style></head><body><main>"
  print "<h1>Descargas y ventas</h1><p>Personas únicas por día, sin robots · Actualizado " ahora " (hora del servidor, UTC) · <a href=\"./\">Estadísticas completas</a></p>"
  print "<div class=\"tot\"><div><b>" (tot["pdf"]+0) "</b><span>Descargas del PDF</span></div><div><b>" (tot["buy"]+0) "</b><span>Clics en Comprar</span></div>"
  print "<div><b>" (tot["test"]+0) "</b><span>Visitas al test</span></div><div><b>" (tot["vis"]+0) "</b><span>Visitas a la web</span></div></div>"
  print "<table><tr><th>Día</th><th>Visitas</th><th>Test</th><th>Descargas</th><th>Comprar</th></tr>"
  nd = 0; for (x in dias) lista[++nd] = x
  for (a = 1; a <= nd; a++) for (b = a + 1; b <= nd; b++) if (lista[b] > lista[a]) { t = lista[a]; lista[a] = lista[b]; lista[b] = t }
  for (a = 1; a <= nd; a++) {
    x = lista[a]
    printf "<tr><td>%s/%s/%s</td><td>%d</td><td>%d</td><td>%d</td><td>%d</td></tr>\n", substr(x, 9, 2), substr(x, 6, 2), substr(x, 1, 4), c["vis|" x], c["test|" x], c["pdf|" x], c["buy|" x]
  }
  print "</table><p style=\"margin-top:20px\">Las ventas confirmadas se ven en Hotmart → Ventas.</p></main></body></html>"
}' > "$OUT.tmp" && mv "$OUT.tmp" "$OUT"
