#!/bin/sh
set -e

if [ "$1" = '' ]; then
    steamcmd +force_install_dir /home/VRisingServer +login anonymous +app_update 1829350 validate +quit

    if [ ! -f /root/.wine ]; then
        echo "Wine not found, installing..."
        winecfg > /dev/null 2>&1
        sleep 5
        echo "Wine installed"
    fi

    if [ ! -f /data/Settings ]; then
        echo "Copy Settings folder"
        cp -r /home/VRisingServer/VRisingServer_Data/StreamingAssets/Settings /data/Settings
    fi

    if [ -f /data/Settings/adminlist.txt ]; then
        echo "Adminlist found, linking..."
        rm -f /home/VRisingServer/VRisingServer_Data/StreamingAssets/Settings/adminlist.txt
        ln -s /data/Settings/adminlist.txt /home/VRisingServer/VRisingServer_Data/StreamingAssets/Settings/adminlist.txt
    fi

    if [ -f /data/Settings/banlist.txt ]; then
        echo "banlist found, linking..."
        rm -f /home/VRisingServer/VRisingServer_Data/StreamingAssets/Settings/banlist.txt
        ln -s /data/Settings/banlist.txt /home/VRisingServer/VRisingServer_Data/StreamingAssets/Settings/banlist.txt
    fi

    cd /home/VRisingServer
    xvfb-run --auto-servernum --server-args='-screen 0 640x480x24:32' wine64 VRisingServer.exe -persistentDataPath Z:/data -logFile Z:/logs/VRisingServer.log >/dev/null 2>&1 &

    tail -f /logs/VRisingServer.log
else
    exec "$@"
fi
