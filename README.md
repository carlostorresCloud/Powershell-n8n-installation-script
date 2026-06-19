```markdown
# 🚀 Instalación Automática de Docker y n8n en Windows

Este repositorio contiene un script de PowerShell diseñado para automatizar por completo la descarga e instalación de **Docker Desktop** en Windows y el despliegue de un contenedor de n8n

---

## ⚙️ ¿Qué hace exactamente el script?

El script ejecuta los siguientes pasos de forma secuencial:

1. **Descarga**: Obtiene la última versión del instalador de Docker Desktop directamente desde los servidores oficiales y la guarda en la carpeta temporal (`%TEMP%`).
2. **Instalación silenciosa**: Instala Docker Desktop automáticamente aceptando los términos de licencia en segundo plano.
3. **Actualización de entorno**: Refresca las variables de entorno (`$PATH`) en la sesión actual para que el comando `docker` esté disponible sin necesidad de reiniciar la consola.
4. **Inicialización y validación**: Inicia Docker Desktop y realiza chequeos constantes (hasta por 3 minutos) esperando a que el motor de Docker responda correctamente.
5. **Persistencia de datos**: Crea un volumen local de Docker llamado `n8n_data`. Esto garantiza que **no pierdas tus flujos de trabajo ni credenciales** si el contenedor se reinicia o se destruye.
6. **Despliegue de n8n**: Descarga e inicia la imagen oficial de n8n, exponiendo el servicio en el puerto `5678`.
7. **Limpieza**: Elimina el instalador temporal descargado para liberar espacio.

---

## 📋 Requisitos Previos

* **Sistema Operativo:** Windows 10 (Build 19044 o superior) o Windows 11.
* **Privilegios:** Debes ejecutar PowerShell como **Administrador**.
* **Requisitos del sistema de Docker:** Es recomendable tener habilitado **WSL 2** (Windows Subsystem for Linux) o la característica de **Hyper-V**.

---

## 🚀 Cómo usar este script

1. Descarga el archivo del script en tu computadora (por ejemplo, `install-n8n.ps1`).
2. Abre **PowerShell como Administrador** (Clic derecho sobre el icono de Inicio de Windows -> Windows PowerShell (Administrador) o Terminal (Administrador)).
3. Navega hasta la carpeta donde descargaste el script:
   ```powershell
   cd C:\Ruta\A\Tu\Carpeta
4. ejecuta el script con \installN8N.ps1 y espera a que se complete
5. entra a https://localhost:5678 en donde estara corriendo n8n
