#!/bin/sh
set -e

if [ "$1" = '' ]; then
    if [ "$VALIDATE" = 'true' ]; then
        steamcmd +force_install_dir /vrising +login anonymous +app_update 1829350 ${GAME_ID} validate +quit
    else
        steamcmd +force_install_dir /vrising +login anonymous +app_update 1829350 ${GAME_ID} +quit
    fi

    if [ ! -d /root/.wine ]; then
        echo "Wine not found, installing..."
        WINEARCH=win64 winecfg > /dev/null 2>&1
        sleep 5
        echo "Wine installed"
    fi

    if [ ! -d /data/Settings ]; then
        echo "Copy default settings..."
        cp -r /home/VRisingServer/VRisingServer_Data/StreamingAssets/Settings /data/Settings
    fi

    if [ -f /data/Settings/adminlist.txt ]; then
        echo "adminlist.txt found, linking..."
        rm -f /home/VRisingServer/VRisingServer_Data/StreamingAssets/Settings/adminlist.txt
        ln -s /data/Settings/adminlist.txt /home/VRisingServer/VRisingServer_Data/StreamingAssets/Settings/adminlist.txt
    fi

    if [ -f /data/Settings/banlist.txt ]; then
        echo "banlist.txt found, linking..."
        rm -f /home/VRisingServer/VRisingServer_Data/StreamingAssets/Settings/banlist.txt
        ln -s /data/Settings/banlist.txt /home/VRisingServer/VRisingServer_Data/StreamingAssets/Settings/banlist.txt
    fi

    cd /home/VRisingServer
    xvfb-run --auto-servernum --server-args='-screen 0 640x480x24:32' wine64 VRisingServer.exe -persistentDataPath Z:/data -logFile Z:/logs/VRisingServer.log ${GAME_PARAMS} >/dev/null 2>&1 &

    tail -f /logs/VRisingServer.log
else
    exec "$@"
fi
