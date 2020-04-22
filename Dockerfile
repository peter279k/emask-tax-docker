FROM ubuntu:18.04

# Install required packages
RUN apt-get update && apt-get install -y firefox firefox-locale-zh-hant dbus-user-session locales tzdata ttf-wqy-microhei sudo

# Install git pakage to clone repositories about card driver, personal certificate card and health ID card clients
RUN apt-get install git wget zip unzip -y

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

# Install personal certificate card client

# Install health ID card client

# Clean up folders and packages
RUN apt-get purge git wget zip unzip -y
RUN apt-get clean -y && apt-get autoremove -y
RUN rm -rf /tmp/* /var/tmp/*

# Execute Firefox with current user
USER user
ENV HOME /home/user
ENV USER user

CMD /usr/bin/firefox
