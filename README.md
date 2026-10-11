# EXPANSIONdeDOMINIO

Página web pública de EXPANSIONdeDOMINIO: *Hábitos emocionales · El método de control interno*.

- `site/`: archivos de la web.
  - `site/index.html`: inicio de la marca con el catálogo de ebooks.
  - `site/habitos-emocionales/`: página de ventas del ebook, con sus imágenes y el PDF gratuito.
  - Para un ebook nuevo: copiar la carpeta `habitos-emocionales/` con otro nombre y cambiar su contenido.
- `docker-compose.yml`: despliegue en el VPS. nginx descarga `site/` y `deploy/nginx.conf` de este repositorio al arrancar y sirve la web en el puerto 8080. GoAccess (instalado en el mismo contenedor) genera las estadísticas en `/estadisticas/` (con contraseña; la contraseña se define solo en Hostinger).
- `deploy/nginx.conf`: configuración de nginx, incluido el destino del botón de compra (`/habitos-emocionales/comprar`).

Este repositorio es público a propósito: solo contiene lo que cualquier visitante ve en la web. La versión de pago **no** está aquí.

Para publicar cambios: subir los cambios a `main` y reiniciar el proyecto `expansiondedominio` en el VPS.
