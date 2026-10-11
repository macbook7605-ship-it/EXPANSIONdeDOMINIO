# EXPANSIONdeDOMINIO

Página web pública de EXPANSIONdeDOMINIO: *La bestia emocional · 100 hábitos de control interno*.

- `site/`: archivos de la web (HTML, CSS, imágenes y el PDF de la versión gratuita).
- `docker-compose.yml`: despliegue en el VPS. Un contenedor nginx descarga la carpeta `site/` de este repositorio al arrancar y la sirve en el puerto 8080.

Este repositorio es público a propósito: solo contiene lo que cualquier visitante ve en la web. La versión de pago **no** está aquí.

Para publicar cambios: subir los cambios a `main` y reiniciar el proyecto `expansiondedominio` en el VPS.
