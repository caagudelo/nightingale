#!/bin/bash
set -e

INSTALL_DIR=/opt/nightingale-server
MARKER=$INSTALL_DIR/.installed

# 1. Instalar solo la primera vez con el AppID de servidor dedicado
if [ ! -f "$MARKER" ]; then
  echo "Instalando Nightingale Dedicated Server (AppID 1928981)..."
  steamcmd +force_install_dir "$INSTALL_DIR" \
           +login anonymous \
           +app_update 1928981 validate \
           +quit

  # Verificar que exista el binario de servidor
  if [ ! -f "$INSTALL_DIR/LinuxNoEditor/NightServer" ]; then
    echo "ERROR: No se encontró el ejecutable en $INSTALL_DIR/LinuxNoEditor/NightServer"
    ls -R "$INSTALL_DIR"
    exit 1
  fi

  touch "$MARKER"
else
  echo "Servidor ya instalado, omitiendo descarga."
fi

# 2. Copiar configuración
cp /opt/config/server.cfg "$INSTALL_DIR/config/server.cfg"

# 3. Iniciar servidor (ruta del binario)
exec "$INSTALL_DIR/LinuxNoEditor/NightServer" \
     -ServerName="${SERVER_NAME}" \
     -MaxPlayers=${MAX_PLAYERS} \
     -Port=${GAME_PORT} \
     -QueryPort=${QUERY_PORT} \
     -RCONPort=${RCON_PORT} \
     -WorldName="${WORLD_NAME}" \
     -Difficulty=${DIFFICULTY} \
     -PvP=${PVP_ENABLED} \
     -AutoSaveInterval=${AUTO_SAVE_INTERVAL} \
     ${SERVER_PASSWORD:+-Password="${SERVER_PASSWORD}"} \
     -log
