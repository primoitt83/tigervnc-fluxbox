#!/bin/bash
if [ -n "$VNC_PASSWORD" ]; then
    echo "$VNC_PASSWORD" | vncpasswd -f > /home/vncuser/.vnc/passwd
    chmod 600 /home/vncuser/.vnc/passwd
fi

vncserver -localhost no -geometry 1920x1080 -depth 24 :1 -fg