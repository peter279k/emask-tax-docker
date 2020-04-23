FROM ubuntu:18.04

# Install required packages
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y firefox firefox-locale-zh-hant dbus-x11 dbus-user-session locales tzdata ttf-wqy-microhei sudo

# Install git pakage to clone repositories about card driver, personal certificate card and health ID card clients
RUN apt-get install wget zip unzip openssl -y

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

# Install root certificate for health ID card client
RUN openssl x509 -in ./cert/NHIRootCA.crt -out ./cert/NHIRootCA.pem
RUN openssl x509 -in ./cert/NHIServerCert.crt -out ./cert/NHIServerCert.pem
COPY ./firefox_policies.json /usr/lib/firefox/distribution/policies.json

# Clean up unnecessary folders and packages
RUN apt-get purge wget zip unzip -y
RUN apt-get clean -y && apt-get autoremove -y
RUN rm -rf 201511920271676073.zip
RUN rm -rf 'Archive created by free jZip.url'
RUN rm -rf EZUSB_Linux/
RUN rm -rf EZUSB_Linux_x86_64_v1.5.3/
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
