#!/bin/sh
set -e

if [ "$1" = '' ]; then
    if [ "$VALIDATE" = 'true' ]; then
        steamcmd +force_install_dir /vrising +login anonymous +app_update ${GAME_ID} validate +quit
    else
        steamcmd +force_install_dir /vrising +login anonymous +app_update ${GAME_ID} +quit
    fi

    if [ ! -d /root/.wine ]; then
        echo "[boot] Wine is not ready, initializing..."
        WINEARCH=win64 winecfg > /dev/null 2>&1
        sleep 5
        echo "[boot] Wine initialized"
    fi

    if [ ! -d /data/Settings ]; then
        echo "[boot] Copy default settings..."
        cp -r /vrising/VRisingServer_Data/StreamingAssets/Settings /data/Settings
    fi

    if [ -f /data/Settings/adminlist.txt ]; then
        echo "[boot] adminlist.txt found, linking..."
        rm -f /vrising/VRisingServer_Data/StreamingAssets/Settings/adminlist.txt
        ln -s /data/Settings/adminlist.txt /vrising/VRisingServer_Data/StreamingAssets/Settings/adminlist.txt
    fi

    if [ -f /data/Settings/banlist.txt ]; then
        echo "[boot] banlist.txt found, linking..."
        rm -f /vrising/VRisingServer_Data/StreamingAssets/Settings/banlist.txt
        ln -s /data/Settings/banlist.txt /vrising/VRisingServer_Data/StreamingAssets/Settings/banlist.txt
    fi

    echo "[boot] Starting VRisingServer..."

    if [ ! -f /logs/VRisingServer.log ]; then
        touch /logs/VRisingServer.log
    fi

    cd /vrising
    xvfb-run --auto-servernum --server-args='-screen 0 640x480x24:32' wine64 VRisingServer.exe -persistentDataPath Z:/data -logFile Z:/logs/VRisingServer.log ${GAME_PARAMS} >/dev/null 2>&1 &

    tail -f /logs/VRisingServer.log
else
    exec "$@"
fi
