#!/bin/bash

start_actions=$1
start_urls=''

if [[ ${start_actions} == '' ]]; then
    echo 'The targeted url option is not specified.'
    echo 'It will start emask and tax urls...'

    start_urls=' https://emask.taiwan.gov.tw/msk/index.jsp https://tax.nat.gov.tw/alltax.html?id=1#'
fi;

if [ ${start_actions} == 'all' ]; then
    echo 'The targeted url option is all.'
    echo 'It will start emask and tax urls...'

    start_urls=' https://emask.taiwan.gov.tw/msk/index.jsp https://tax.nat.gov.tw/alltax.html?id=1#'
fi;

if [ ${start_actions} == 'emask' ]; then
    echo 'The targeted url option is emask.'
    echo 'It will start emask url...'

    start_urls=' https://emask.taiwan.gov.tw/msk/index.jsp'
fi;

if [ ${start_actions} == 'tax' ]; then
    echo 'The targeted url option is tax.'
    echo 'It will start tax url...'

    start_urls=' https://tax.nat.gov.tw/alltax.html?id=1#'
fi;

if [ ${start_actions} != 'emask' ] && [ ${start_actions} != 'tax' ] && [ ${start_actions} != 'all' ]; then
    echo 'Unknown start_urls option!'
    echo 'Stopped.'

    exit 1;
fi;

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
    ${sudo_pefix}/etc/init.d/pcsc_scan stop
    ${sudo_pefix}service pcsc_scan stop
    ${sudo_pefix}systemctl stop pcsc_scan
fi;

sudo_pefix=''
echo 'Check current user can execute docker command...'
cat /etc/group | grep docker | grep $USER 2>&1 > /dev/null

if [ $? != 0 ]; then
    sudo_pefix='sudo '
fi;

echo "Running ${start_actions} url..."
${sudo_pefix}docker run -it \
    --env DISPLAY=$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    docker-firefox:latest \
    firefox${start_urls}
