#!/bin/bash
set -e

# 1. Descargar/actualizar Nightingale Dedicated Server
steamcmd +force_install_dir /opt/nightingale-server \
         +login anonymous \
         +app_update 1928981 validate \
         +quit

# 2. Copiar configuración
cp /opt/config/server.cfg /opt/nightingale-server/server.cfg

# 3. Iniciar servidor Nightingale
exec /opt/nightingale-server/NightingaleServer \
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
