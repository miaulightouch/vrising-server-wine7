FROM steamcmd/steamcmd:ubuntu-20

COPY docker-entrypoint.sh /docker-entrypoint.sh

ARG DEBIAN_FRONTEND="noninteractive"

ENV TZ=Etc/UTC
ENV GAME_ID=1829350
ENV GAME_PARAMS=
ENV VALIDATE=true

RUN apt update && \
    apt-get install --no-install-recommends -y wget && \
    wget -nc https://dl.winehq.org/wine-builds/winehq.key && \
    mv winehq.key /usr/share/keyrings/winehq-archive.key && \
    wget -nc https://dl.winehq.org/wine-builds/ubuntu/dists/focal/winehq-focal.sources && \
    mv winehq-focal.sources /etc/apt/sources.list.d/ && \
    apt update && \
    apt install --no-install-recommends -y winehq-stable xvfb && \
    rm -rf /var/lib/apt/lists/* && \
    apt remove --purge -y wget && \
    apt clean && \
    apt autoremove -y && \
    mkdir /data && \
    mkdir /logs && \
    mkdir /vrising && \
    chmod +x /docker-entrypoint.sh

ENTRYPOINT [ "/docker-entrypoint.sh" ]
CMD []
