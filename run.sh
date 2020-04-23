#!/bin/bash

web_browser=$1

if [[ ${web_browser} == '' ]] || [[ ${web_browser} == 'firefox' ]]; then
    echo 'Sorry! The Firefox web browser is deprecated.'
    echo 'Using the google-chrome-stable instead...'
fi;

web_browser='google-chrome-stable --no-sandbox --use-gl=swiftshader  --ignore-certificate-errors --unsafely-treat-insecure-origin-as-secure=https://localhost:7777 --unsafely-treat-insecure-origin-as-secure=https://iccert.nhi.gov.tw:7777'

emask_url='https://emask.taiwan.gov.tw/msk/index.jsp'
tax_url='https://tax.nat.gov.tw/alltax.html?id=1#'

# Start smart card redaer scanning
sudo /etc/init.d/pcscd start
pcsc_scan &

if [ $? != 0 ]; then
    echo 'It seeme that the smart card reader daemon is not executed currently...'
    echo 'Stopped it.'
    exit 1;
fi;

# Start local Personal certificate client
cd /usr/local/HiPKILocalSignServerApp && ./start.sh & 2>&1 > /tmp/HiPKILocalSignServerApp.log

echo 'The HiPKILocalSignServerApp log is available for /tmp/HiPKILocalSignServerApp.log'

ps aux | grep start.sh 2>&1 > /dev/null

if [ $? != 0 ]; then
    echo 'It seeme that the HiPKILocalSignServerApp daemon is not executed currently...'
    echo 'Stopped it.'
    exit 1;
fi;

# Start plugin for health ID card
sudo /etc/init.d/NHIICC.sh 2>&1 > /tmp/NHIICC.log

echo 'The NHIIC log is available for /tmp/NHIIC.log'

ps aux | grep mLNHIICC 2>&1 > /dev/null

if [ $? != 0 ]; then
    echo 'It seeme that the mLNHIICC daemon is not executed currently...'
    echo 'Stopped it.'
    echo 'Please restart start.sh again...'
    exit 1;
fi;

${web_browser} ${emask_url} ${tax_url} ${iccert_nhi_url}
