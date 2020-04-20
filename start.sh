#!/bin/bash

which docker 2>&1 > /dev/null

if [ $? != 0 ]; then
    echo 'Docker command not found. Stater has been stopped...'
    exit 1;
fi;

echo 'Stopping card scanner...'


docker run -it \
    --env DISPLAY=$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    docker-firefox:latest \
    firefox
