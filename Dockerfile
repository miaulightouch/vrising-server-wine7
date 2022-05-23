FROM steamcmd/steamcmd:ubuntu-20

ENV TZ="America/New_York"

COPY docker-entrypoint.sh /docker-entrypoint.sh

RUN DEBIAN_FRONTEND="noninteractive" apt update && \
    apt-get install --no-install-recommends -y wget && \
    wget -nc https://dl.winehq.org/wine-builds/winehq.key && \
    mv winehq.key /usr/share/keyrings/winehq-archive.key && \
    wget -nc https://dl.winehq.org/wine-builds/ubuntu/dists/focal/winehq-focal.sources && \
    mv winehq-focal.sources /etc/apt/sources.list.d/ && \
    apt update && \
    apt install --no-install-recommends -y winehq-stable xvfb && \
    rm -rf /var/lib/apt/lists/* && \
    apt clean && \
    apt autoremove -y && \
    mkdir /data && \
    mkdir /logs && \
    WINEARCH=wine64 winecfg && \
    sleep 5 && \
    chmod +x /docker-entrypoint.sh

ENTRYPOINT [ "docker-enrtypoint.sh" ]
