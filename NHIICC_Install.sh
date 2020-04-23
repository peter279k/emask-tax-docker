#!/bin/bash

# Create NHIICC folder and copy rerquire files to these folders
mkdir -p /usr/local/share/NHIICC && chmod 755 /usr/local/share/NHIICC
cp ./x64/mLNHIICC /usr/local/share/NHIICC/mLNHIICC
chmod 755 /usr/local/share/NHIICC/mLNHIICC  && cp -R ./html /usr/local/share/NHIICC && cp -R ./cert /usr/local/share/NHIICC

# Let iccert.nhi.gov.tw domain let Docker container know about redirecting to localhost IP address
echo '127.0.0.1 iccert.nhi.gov.tw' >> /etc/hosts

# Install required packages for NHIICC client
apt-get update
apt-get install -y libc6
apt-get install -y libssl1.0.0 libssl-dev --reinstall

# Create NHIICC shell script to execute mLNHIICC client daemon
echo '#!/bin/bash' >> /etc/init.d/NHIICC.sh
echo '' >> /etc/init.d/NHIICC.sh
echo '' >> /etc/init.d/NHIICC.sh
echo '/usr/local/share/NHIICC/mLNHIICC &' >> /etc/init.d/NHIICC.sh
echo '' >> /etc/init.d/NHIICC.sh

# Set above NHICC.sh script to be soflink to anothetr specific file path
chmod 755 /etc/init.d/NHIICC.sh
if [ -f /etc/rc5.d/S50NHIICC.sh ]; then
    unlink /etc/rc5.d/S50NHIICC.sh
fi;
ln -s /etc/init.d/NHIICC.sh /etc/rc5.d/S50NHIICC.sh
