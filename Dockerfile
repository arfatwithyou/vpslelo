FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Kolkata

# System packages
RUN apt-get update && apt-get install -y \
    openssh-server sudo curl wget git \
    nano vim htop neofetch screen tmux \
    python3 python3-pip python3-venv \
    nodejs npm \
    build-essential gcc g++ make cmake \
    zip unzip tar gzip \
    net-tools iputils-ping dnsutils \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*

# SSH folder ready karo
RUN mkdir -p /var/run/sshd

# SSH config — password auth on, root login on
RUN sed -i 's/#PermitRootLogin.*/PermitRootLogin yes/'       /etc/ssh/sshd_config && \
    sed -i 's/PermitRootLogin.*/PermitRootLogin yes/'         /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/PasswordAuthentication.*/PasswordAuthentication yes/'  /etc/ssh/sshd_config && \
    echo "MaxSessions 20"           >> /etc/ssh/sshd_config && \
    echo "ClientAliveInterval 60"   >> /etc/ssh/sshd_config && \
    echo "ClientAliveCountMax 5"    >> /etc/ssh/sshd_config && \
    echo "TCPKeepAlive yes"         >> /etc/ssh/sshd_config

# kittu user banao (sudo wala)
RUN useradd -m -s /bin/bash kittu && \
    usermod -aG sudo kittu && \
    echo "kittu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# start script copy karo
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Welcome banner
RUN printf '\n\033[1;36m╔══════════════════════════════════════╗\n║   🚀  Railway Ubuntu VPS by Kittu   ║\n╚══════════════════════════════════════╝\033[0m\nType \033[1msysinfo\033[0m to check RAM / CPU\n' \
    > /etc/motd

# sysinfo shortcut
RUN printf '#!/bin/bash\necho ""\necho "=== System Info ==="\nuname -a\necho ""\necho "=== CPU ==="\nnproc && lscpu | grep "Model name"\necho ""\necho "=== RAM ==="\nfree -h\necho ""\necho "=== Disk ==="\ndf -h /\necho ""\n' \
    > /usr/local/bin/sysinfo && chmod +x /usr/local/bin/sysinfo

EXPOSE 22

CMD ["/start.sh"]
