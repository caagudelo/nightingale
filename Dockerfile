# 1. Imagen base con SteamCMD
FROM steamcmd/steamcmd:latest

# 2. Variables de entorno por defecto
ARG SERVER_NAME="NSC SERVER"
ARG MAX_PLAYERS=6
ARG SERVER_PASSWORD="SinEconomia"
ARG WORLD_NAME="NSC"
ARG DIFFICULTY="Normal"
ARG PVP_ENABLED="false"
ARG AUTO_SAVE_INTERVAL=300
ARG GAME_PORT=7777
ARG QUERY_PORT=27015
ARG RCON_PORT=27020
ARG TZ="America/Bogota"

ENV SERVER_NAME=${SERVER_NAME} \
    MAX_PLAYERS=${MAX_PLAYERS} \
    SERVER_PASSWORD=${SERVER_PASSWORD} \
    WORLD_NAME=${WORLD_NAME} \
    DIFFICULTY=${DIFFICULTY} \
    PVP_ENABLED=${PVP_ENABLED} \
    AUTO_SAVE_INTERVAL=${AUTO_SAVE_INTERVAL} \
    GAME_PORT=${GAME_PORT} \
    QUERY_PORT=${QUERY_PORT} \
    RCON_PORT=${RCON_PORT} \
    TZ=${TZ}

# 3. Crear directorios
RUN mkdir -p /opt/nightingale-server /opt/config /opt/logs /opt/scripts
WORKDIR /opt/nightingale-server

# 4. Copiar configuración y script de arranque
COPY config/server.cfg /opt/config/server.cfg
COPY entrypoint.sh /opt/scripts/entrypoint.sh
RUN chmod +x /opt/scripts/entrypoint.sh

# 5. Definir zona horaria
RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone

# 6. Exponer puertos del juego
EXPOSE ${GAME_PORT}/udp ${QUERY_PORT}/udp ${RCON_PORT}/tcp

# 7. Entry point
ENTRYPOINT ["/opt/scripts/entrypoint.sh"]
