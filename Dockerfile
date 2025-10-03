FROM cm2network/steamcmd:latest

RUN mkdir -p /opt/nightingale \
 && steamcmd +login anonymous \
            +force_install_dir /opt/nightingale \
            +app_update 3796810 validate \
            +quit

WORKDIR /opt/nightingale
EXPOSE 7777/udp 27015/udp

CMD ["bash","-lc","./NWXServer.sh -batchmode -nographics"]