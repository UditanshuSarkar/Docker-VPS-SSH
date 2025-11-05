FROM ubuntu:20.04

# Environment setup
ENV DEBIAN_FRONTEND=noninteractive \
    ROOT_PASSWORD=root \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

# Install essentials
RUN apt-get update && apt-get install -y \
    openssh-server \
    wget \
    curl \
    unzip \
    net-tools \
    htop \
    nano \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Setup SSH
RUN mkdir -p /var/run/sshd /root/.ssh \
    && echo "PermitRootLogin yes" >> /etc/ssh/sshd_config \
    && echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config \
    && echo "X11Forwarding yes" >> /etc/ssh/sshd_config \
    && echo "ClientAliveInterval 120" >> /etc/ssh/sshd_config \
    && echo "ClientAliveCountMax 2" >> /etc/ssh/sshd_config \
    && echo "root:${ROOT_PASSWORD}" | chpasswd

# Install Playit.gg tunnel client
RUN wget -q https://github.com/playit-cloud/playit-agent/releases/latest/download/playit-linux-amd64 \
    && mv playit-linux-amd64 /usr/local/bin/playit \
    && chmod +x /usr/local/bin/playit

# Copy startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Expose SSH port
EXPOSE 22

# Start SSH + Playit tunnel
CMD ["/bin/bash", "/start.sh"]
