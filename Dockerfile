FROM kalilinux/kali-rolling

RUN apt-get update --fix-missing
RUN DEBIAN_FRONTEND=noninteractive apt install -y kali-desktop-xfce dbus-x11

RUN rm -f /run/reboot-required*

RUN useradd -m user1 -p $(openssl passwd user1)
RUN usermod -aG sudo user1
RUN echo "root:root" | chpasswd

RUN apt install -y xrdp
RUN adduser xrdp ssl-cert

RUN sed -i '3 a echo "\
export GNOME_SHELL_SESSION_MODE=kali\\n\
export XDG_SESSION_TYPE=x11\\n\
export XDG_CURRENT_DESKTOP=kali:GNOME\\n\
export XDG_CONFIG_DIRS=/etc/xdg/xdg-kali:/etc/xdg\\n\
" > ~/.xsessionrc' /etc/xrdp/startwm.sh
RUN apt-get install -y '^libxcb.*-dev' libx11-xcb-dev libglu1-mesa-dev libxrender-dev libxi-dev libxkbcommon-dev libxkbcommon-x11-dev libxcb-util1

RUN apt-get install -y libgl1-mesa-dev libdbus-1-3
RUN apt-get install -y python3
RUN apt-get install -y cmake
RUN apt-get install -y nano
RUN apt-get install -y iputils-ping
RUN apt-get install -y sudo
RUN apt-get install -y nmap
RUN apt-get install -y pip
RUN apt-get install -y wireguard

RUN apt install -y build-essential flex bison \
    libgtk-3-dev libelf-dev libncurses-dev autoconf \
    libudev-dev libtool zip unzip v4l-utils libssl-dev \
    python3-pip cmake git iputils-ping net-tools dwarves \
    python-is-python3 bc v4l-utils \
    metasploit-framework burpsuite sqlmap hydra \
    libopencv-dev python3-opencv python3-pyqt5 \
    python3-pyqt5.qtwebengine python3-pyqt5.qtsvg \
    firefox-esr

WORKDIR /home/user1/    
COPY requirements.txt /
RUN apt-get install -y pipx
RUN pip install -r requirements.txt --break-system-packages

EXPOSE 3389

CMD service dbus start; /usr/lib/systemd/systemd-logind & service xrdp start ; /bin/bash
