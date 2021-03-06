# V-Rising Server Docker

V-Rising Server run on latest wine.

This docker image based on [BorkforceOne/V-Rising-Docker-Linux](https://github.com/BorkforceOne/V-Rising-Docker-Linux), [ich777/docker-steamcmd-server@v-rising](https://github.com/ich777/docker-steamcmd-server/tree/vrising) and [steamcmd/steamcmd](https://github.com/steamcmd/docker).

To config your server, please apply your settings by editing `ServerHostSettings.json` and `ServerGameSettings.json` directly and mount to `/data/Settings` in container. (it's recommended to mount whole `/data` to host filesystem to keep game progress, or it would be lost.)

Default server setting files are all placed in `data` folder, you can use these file to start your server.

## Available tags

- [`main`, `latest`](https://github.com/miaulightouch/vrising-server-wine7/blob/main/Dockerfile) use latest `winehq-stable`
- [`staging`](https://github.com/miaulightouch/vrising-server-wine7/blob/staging/Dockerfile) use latest `winehq-staging`
- [`edge`](https://github.com/miaulightouch/vrising-server-wine7/blob/edge/Dockerfile) use latest `winehq-devel`

## Folder Structure in container

```plain
/
├─ data
│  ├─ Saves
│  └─ Settings
│
├─ logs
│  └─ VRisingServer.log
│
└─ vrising               # server files
```

## Env Options

| Name | Default | Description |
| ---- |:-------:| ----------- |
| TZ | Etc/UTC | Timezone |
| GAME_ID | 1829350 | The GAME_ID that download from steam at startup
| GAME_PARAMS | "" | additional parameter for server launch
| VALIDATE | true | validate server files when container startup

## Example

### Docker run

```sh
docker run --name V-Rising -d \
        -p 9876-9877:9876-9877/udp \
        -e 'TZ=America/New_York' \    # optional
        -e 'GAME_ID=1829350' \        # optional
        -e 'GAME_PARAMS=' \           # optional
        -e 'VALIDATE=true' \          # optional
        -v /path/to/data:/data \
        -v /path/to/logs:/logs \      # optional
        -v /path/to/server:/vrising \ # optional, no need to mount for most case
        miaulightouch/vrising-server-wine7
```

### Docker Compose

```yml
version: "3"

services:
  vrising:
    image: miaulightouch/vrising-server-wine7
    container_name: vrising
    environment:
      - TZ=America/New_York       # optional
      - GAME_ID=1829350           # optional
      - GAME_PARAMS=              # optional
      - VALIDATE=true             # optional
    volumes:
      - /path/to/data:/data       # optional
      - /path/to/logs:/logs       # optional
      - /path/to/server:/vrising  # optional, no need to mount for most case
    ports:
      - 9876-9877:9876-9877/udp
    restart: unless-stopped
```
