# 1. Usar imagen de SteamCMD que expone el binario correctamente
FROM steamcmd/steamcmd:latest

# 2. Variables de entorno por defecto
ENV SERVER_NAME="Mi Servidor Nightingale" \
    MAX_PLAYERS=6 \
    SERVER_PASSWORD="" \
    WORLD_NAME="NSC" \
    DIFFICULTY="Normal" \
    PVP_ENABLED="false" \
    AUTO_SAVE_INTERVAL=300 \
    GAME_PORT=7777 \
    QUERY_PORT=27015 \
    RCON_PORT=27020 \
    TZ="America/Bogota"

# 3. Crear directorios de trabajo
RUN mkdir -p /opt/nightingale-server /opt/config /opt/logs
WORKDIR /opt/nightingale-server

# 4. Descargar/actualizar Nightingale Dedicated Server
RUN steamcmd +force_install_dir /opt/nightingale-server \
    +login anonymous \
    +app_update 1928981 validate \
    +quit

# 5. Copiar configuración predeterminada
COPY config/server.cfg /opt/config/server.cfg

# 6. Definir zona horaria
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 7. Exponer puertos del juego
EXPOSE ${GAME_PORT}/udp ${QUERY_PORT}/udp ${RCON_PORT}/tcp

# 8. Punto de entrada para iniciar el servidor
ENTRYPOINT ["bash","-c","\
  cp /opt/config/server.cfg /opt/nightingale-server/server.cfg && \
  ./NightingaleServer \
    -ServerName='${SERVER_NAME}' \
    -MaxPlayers=${MAX_PLAYERS} \
    -Port=${GAME_PORT} \
    -QueryPort=${QUERY_PORT} \
    -RCONPort=${RCON_PORT} \
    -WorldName='${WORLD_NAME}' \
    -Difficulty=${DIFFICULTY} \
    -PvP=${PVP_ENABLED} \
    -AutoSaveInterval=${AUTO_SAVE_INTERVAL} \
    ${SERVER_PASSWORD:+-Password='${SERVER_PASSWORD}'} \
    -log \
"]
