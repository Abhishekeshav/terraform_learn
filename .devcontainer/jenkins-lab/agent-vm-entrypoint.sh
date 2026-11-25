#!/bin/sh
set -e
mkdir -p /home/ubuntu/.ssh
echo "$AUTHORIZED_KEY" > /home/ubuntu/.ssh/authorized_keys
chown -R ubuntu:ubuntu /home/ubuntu/.ssh
chmod 700 /home/ubuntu/.ssh
chmod 600 /home/ubuntu/.ssh/authorized_keys
exec /usr/sbin/sshd -D -e
