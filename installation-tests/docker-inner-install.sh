#!/usr/bin/env bash
# Executed inside the test container (as root first, then testuser for install.sh).
set -euxo pipefail
export DEBIAN_FRONTEND=noninteractive
export TERM="${TERM:-xterm-256color}"
apt-get update -qq
apt-get install -y -qq sudo git curl ca-certificates locales file
useradd -m -s /bin/bash testuser 2>/dev/null || true
echo 'testuser ALL=(ALL) NOPASSWD:ALL' >/etc/sudoers.d/testuser
chmod 440 /etc/sudoers.d/testuser
rm -rf /home/testuser/dotfiles
cp -a /dotfiles-src /home/testuser/dotfiles
chown -R testuser:testuser /home/testuser/dotfiles
sudo -u testuser -H env TERM="$TERM" CI=1 bash -lc 'cd ~/dotfiles && chmod +x install.sh && ./install.sh -c'
