#!/bin/bash

echo 'Check whether docker package is installed...'
which docker 2>&1 > /dev/null

sudo_pefix=''
if [ ${USER} != 'root' ]; then
    sudo_pefix='sudo '
fi;

if [ $? != 0 ]; then
    echo 'Docker command is not found. Stater has been stopped...'
    exit 1;
fi;

echo 'Stopping card scanner...'

which pcsc_scan 2>&1 > /dev/null

if [ $? != 0 ]; then
    echo 'pcsc_scan command is not found...'
    echo 'Skip stopping card scanner on host...'
else
    echo 'Disable pcscd service daemon on host system...'

    ${sudo_pefix}/etc/init.d/pcscd stop
    ${sudo_pefix}service pcscd stop
    ${sudo_pefix}systemctl stop pcscd.service
    ${sudo_pefix}systemctl stop pcscd.socket
    ${sudo_pefix}systemctl disable pcscd.service
    ${sudo_pefix}systemctl disable pcscd.socket
fi;

sudo_pefix=''
echo 'Check current user can execute docker command...'
cat /etc/group | grep docker | grep $USER 2>&1 > /dev/null

if [ $? != 0 ]; then
    sudo_pefix='sudo '
fi;

# Ensure user can connect to X server on localhost
xhost +localhost

echo "Running Docker container..."
${sudo_pefix}docker run -it \
    --env DISPLAY=$DISPLAY \
    --device /dev/bus/usb:/dev/bus/usb \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    emask-tax-docker:latest \
    ./run.sh
