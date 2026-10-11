# EXPANSIONdeDOMINIO

Página web pública de EXPANSIONdeDOMINIO: *La bestia emocional · 100 hábitos de control interno*.

- `site/`: archivos de la web.
  - `site/index.html`: inicio de la marca con el catálogo de ebooks.
  - `site/la-bestia-emocional/`: página de ventas del ebook, con sus imágenes y el PDF gratuito.
  - Para un ebook nuevo: copiar la carpeta `la-bestia-emocional/` con otro nombre y cambiar su contenido.
- `docker-compose.yml`: despliegue en el VPS. Un contenedor nginx descarga la carpeta `site/` de este repositorio al arrancar y la sirve en el puerto 8080.

Este repositorio es público a propósito: solo contiene lo que cualquier visitante ve en la web. La versión de pago **no** está aquí.

Para publicar cambios: subir los cambios a `main` y reiniciar el proyecto `expansiondedominio` en el VPS.
