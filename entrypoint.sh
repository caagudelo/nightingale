#!/bin/bash
set -e

INSTALL_DIR=/opt/nightingale-server
MARKER=$INSTALL_DIR/.installed

# 1. Si no está instalado, descarga/actualiza
if [ ! -f "$MARKER" ]; then
  echo "Instalando Nightingale Dedicated Server..."
  steamcmd +force_install_dir "$INSTALL_DIR" \
           +login anonymous \
           +app_update 3796810 validate \
           +quit

  # Crear archivo marcador para futuros inicios
  touch "$MARKER"
else
  echo "Servidor ya instalado, omitiendo descarga."
fi

# 2. Copiar configuración
cp /opt/config/server.cfg "$INSTALL_DIR/server.cfg"

# 3. Iniciar servidor Nightingale
exec "$INSTALL_DIR/NightingaleServer" \
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
