#! /bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# disable KDE composition to get double buffering for Wine
qdbus org.kde.KWin /Compositor suspend

# inhibit automatic sleep and screen locking
# launch the inhibitor in the background and keep it running
# as the inhibit is automatically released when when the process that set it dies.

python3 "${SCRIPT_DIR}/inhibit.py" &
INHIBIT_PID=$!

WINEPREFIX="${WINEPREFIX:-$HOME/.wine}"

cd "${WINEPREFIX}/drive_c/Program Files/Genshin Impact/Genshin Impact game"

# configure game contollers (PS3 Doublshock, Xbox Wireless)
# could configure the entire db if needed
export SDL_GAMECONTROLLERCONFIG="050000004c0500006802000000800000,PS3 Controller,a:b0,b:b1,back:b8,dpdown:b14,dpleft:b15,dpright:b16,dpup:b13,guide:b10,leftshoulder:b4,leftstick:b11,lefttrigger:a2,leftx:a0,lefty:a1,rightshoulder:b5,rightstick:b12,righttrigger:a5,rightx:a3,righty:a4,start:b9,x:b3,y:b2,platform:Linux,
050000005e040000130b000009050000,Xbox Series Controller,a:b0,b:b1,back:b10,dpdown:h0.4,dpleft:h0.8,dpright:h0.2,dpup:h0.1,guide:b12,leftshoulder:b6,leftstick:b13,lefttrigger:a5,leftx:a0,lefty:a1,rightshoulder:b7,rightstick:b14,righttrigger:a4,rightx:a2,righty:a3,start:b11,x:b3,y:b4,platform:Linux,"

# Configure DXVK Headup Display settings .. if you fancy it
#export DXVK_HUD=version,devinfo,fps
#export DXVK_HUD=version,fps
#export DXVK_HUD=api,fps

wine cmd /c launcher.bat

# game got launched in the background
sleep 1

# find it's process id matching the full commandline
GAME_PID=$( pgrep -f GenshinImpact.exe )
# wait for this process
tail --pid=$GAME_PID -f /dev/null

# shut down the inhibitor gracefully
kill -s SIGINT $INHIBIT_PID

# enable KDE composition again
qdbus org.kde.KWin /Compositor resume
