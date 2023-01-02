#!/bin/bash
# Dynamic wallpaper based on sunrise / sunset
# Only for KDE Plasma
# Remember to add this script to autostart

# IMPORTANT: DO NOT SHARE THIS SCRIPT WITH LATITUDE AND LONGTUDE SET! IT'S YOUR LOCATION!
# Get your latitude at https://www.latlong.net/
LATITUDE=51.507351
LONGITUDE=-0.127758

# Paths to wallpapers
# Change user here
DAY_WALLPAPER=home/user/wallpapers/wallpaper-day.jpg
NIGHT_WALLPAPER=home/user/wallpapers/wallpaper-night.jpg

# Takes $1 as path to file
change_wallpaper ()
{
    dbus-send --session --dest=org.kde.plasmashell --type=method_call /PlasmaShell org.kde.PlasmaShell.evaluateScript 'string:
    var Desktops = desktops();
    for (i=0;i<Desktops.length;i++) {
            d = Desktops[i];
            d.wallpaperPlugin = "org.kde.image";
            d.currentConfigGroup = Array("Wallpaper",
                                        "org.kde.image",
                                        "General");
            d.writeConfig("Image", "file:///'$1'");
    }'
}

while true
do
    change_wallpaper "$NIGHT_WALLPAPER"
    sleep 3
    echo Waiting for sunrise
    sunwait wait rise ${LATITUDE}N ${LONGITUDE}E
    echo Changing wallpaper to DAY
    change_wallpaper "$DAY_WALLPAPER"
    sleep 10
    echo Waiting for sunset
    sunwait wait set ${LATITUDE}N ${LONGITUDE}E
    echo Changing wallpaper to NIGHT
    change_wallpaper "$NIGHT_WALLPAPER"
    sleep 10
done
