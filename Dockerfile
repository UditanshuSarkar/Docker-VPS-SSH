# 🧱 Base Image
FROM ubuntu:20.04

# 🛠 Set environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    NGROK_VERSION=3-stable \
    ROOT_PASSWORD=root \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

# 📦 Install essential packages
RUN apt-get update && apt-get install -y \
    openssh-server \
    wget \
    curl \
    unzip \
    net-tools \
    htop \
    nano \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 🔒 Setup SSH
RUN mkdir -p /var/run/sshd /root/.ssh \
    && echo "PermitRootLogin yes" >> /etc/ssh/sshd_config \
    && echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config \
    && echo "X11Forwarding yes" >> /etc/ssh/sshd_config \
    && echo "ClientAliveInterval 120" >> /etc/ssh/sshd_config \
    && echo "ClientAliveCountMax 2" >> /etc/ssh/sshd_config \
    && echo "root:${ROOT_PASSWORD}" | chpasswd

# ⚡ Install Ngrok (latest v3)
RUN wget -q https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v${NGROK_VERSION}-linux-amd64.tgz \
    && tar -xzf ngrok-v${NGROK_VERSION}-linux-amd64.tgz -C /usr/local/bin \
    && chmod +x /usr/local/bin/ngrok \
    && rm ngrok-v${NGROK_VERSION}-linux-amd64.tgz

# 📂 Add ngrok authtoken securely
# 👉 Replace below token with yours during build OR use ARG for CI/CD flexibility
ARG NGROK_AUTHTOKEN
RUN ngrok config add-authtoken $NGROK_AUTHTOKEN

# 🧩 Optional startup script for flexibility
COPY start.sh /start.sh
RUN chmod +x /start.sh

# 🔥 Expose SSH port
EXPOSE 22

# 🚀 Start SSH and Ngrok tunnel together
CMD ["/bin/bash", "/start.sh"]
