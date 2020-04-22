FROM ubuntu:18.04

# Install required packages
RUN apt-get update && apt-get install -y firefox firefox-locale-zh-hant dbus-user-session locales tzdata ttf-wqy-microhei sudo

# Install git pakage to clone repositories about card driver, personal certificate card and health ID card clients
RUN apt-get install wget zip unzip -y

# Install card tool packages
RUN apt-get update && apt-get install pcscd pcsc-tools -y

# Create user named user and let user can use sudo
RUN useradd -s /bin/bash -u 1000 user
RUN mkdir /home/user
RUN chown -R user:user /home/user
RUN gpasswd -a user sudo

# Set timezone to Asia/Taipei
ENV TZ=Asia/Taipei
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Set locale to zh_TW.UTF-8
RUN locale-gen "zh_TW.UTF-8"
RUN echo 'LC_ALL="zh_TW.UTF-8"' > /etc/default/locale

# Install Card Driver
RUN wget --no-check-certificate https://www.castlestech.com/wp-content/uploads/2016/08/201511920271676073.zip
RUN unzip 201511920271676073.zip
RUN unzip EZUSB_Linux/EZUSB_Linux_x86_64_v1.5.3.zip
RUN cd EZUSB_Linux_x86_64_v1.5.3/driver_ezusb_v1.5.3_for_64_bit/ && ./driver_install

# Install personal certificate card client

# Install health ID card client

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

CMD /usr/bin/firefox
