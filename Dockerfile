FROM ubuntu:18.04

# Install required packages
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends --no-upgrade -y \
    locales \
    tzdata \
    ttf-wqy-microhei \
    sudo

# Install git pakage to clone repositories about card driver, personal certificate card and health ID card clients
RUN apt-get install --no-install-recommends --no-upgrade wget zip unzip ca-certificates openssl libnss3-tools -y

# Install google-chrome-stable web browser package and some recommended packages
RUN wget --no-check-certificate  https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN apt-get install --no-install-recommends --no-upgrade -y \
    packagekit-gtk3-module \
    libcanberra-gtk-module \
    fonts-liberation \
    libappindicator3-1 \
    libxss1 \
    xdg-utils \
    libxcb-dri3-0 \
    libx11-xcb1 \
    libgbm1 \
    libdrm2 \
    libxtst6
RUN dpkg -i ./google-chrome-stable_current_amd64.deb

# Install card tool packages
RUN apt-get update && apt-get install pcscd pcsc-tools -y

# Create user named user and let user can use sudo without password
RUN useradd -s /bin/bash -u 1000 user
RUN mkdir /home/user
RUN chown -R user:user /home/user
RUN echo 'user     ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Set timezone to Asia/Taipei
ENV TZ=Asia/Taipei
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Set locale to zh_TW.UTF-8
RUN locale-gen "zh_TW.UTF-8"
RUN echo 'LC_ALL="zh_TW.UTF-8"' > /etc/default/locale

# Install Card Driver for EZ100PU
WORKDIR /usr/local
RUN wget --no-check-certificate https://www.castlestech.com/wp-content/uploads/2016/08/201511920271676073.zip
RUN unzip 201511920271676073.zip
RUN unzip EZUSB_Linux/EZUSB_Linux_x86_64_v1.5.3.zip
RUN mkdir -p /usr/lib/pcsc/drivers/ezusb.bundle/Contents/Linux
RUN cp ./EZUSB_Linux_x86_64_v1.5.3/driver_ezusb_v1.5.3_for_64_bit/drivers/ezusb.so /usr/lib/pcsc/drivers/ezusb.bundle/Contents/Linux
RUN cp ./EZUSB_Linux_x86_64_v1.5.3//driver_ezusb_v1.5.3_for_64_bit/drivers/Info.plist /usr/lib/pcsc/drivers/ezusb.bundle/Contents

# Install personal certificate card client
RUN wget --no-check-certificate https://api-hisecurecdn.cdn.hinet.net/HiPKILocalSignServer/linux/HiPKILocalSignServerApp.tar.gz
RUN tar zxvf HiPKILocalSignServerApp.tar.gz

# Install health ID card client
RUN wget --no-check-certificate https://cloudicweb.nhi.gov.tw/cloudic/system/SMC/mLNHIICC_Setup.Ubuntu.zip
RUN unzip mLNHIICC_Setup.Ubuntu.zip && tar zxvf mLNHIICC_Setup.tar.gz

WORKDIR /usr/local/mLNHIICC_Setup
COPY NHIICC_Install.sh ./
RUN ./NHIICC_Install.sh

# Clean up unnecessary folders and packages
RUN apt-get purge zip unzip -y
RUN apt-get clean -y && apt-get autoremove -y
RUN rm -f /google-chrome-stable_current_amd64.deb
RUN rm -rf /usr/local/201511920271676073.zip
RUN rm -rf /usr/local/'Archive created by free jZip.url'
RUN rm -rf /usr/local/EZUSB_Linux/
RUN rm -rf /usr/local/EZUSB_Linux_x86_64_v1.5.3/
RUN rm -rf /usr/local/mLNHIICC_Setup/
RUN rm -rf /usr/local/*.zip
RUN rm -rf /usr/local/*.tar.gz
RUN rm -rf /tmp/* /var/tmp/*

# Execute Firefox with current user
USER user
ENV HOME /home/user
ENV USER user

WORKDIR /home/user
COPY run.sh run.sh

RUN mkdir .cache
COPY smartcard_list.txt ./.cache/smartcard_list.txt

CMD ["bash", "-c", "./run.sh"]
