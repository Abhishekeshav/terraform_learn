# A minimal Ubuntu "server" with SSH, standing in for the video's second EC2 instance.
FROM ubuntu:24.04
RUN apt-get update \
 && apt-get install -y --no-install-recommends openssh-server sudo ca-certificates curl \
 && mkdir -p /run/sshd \
 && usermod -p '*' ubuntu \
 && echo 'ubuntu ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/ubuntu \
 && rm -rf /var/lib/apt/lists/*
COPY agent-vm-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
EXPOSE 22
ENTRYPOINT ["/entrypoint.sh"]
