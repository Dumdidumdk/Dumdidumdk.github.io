#!/usr/bin/env bash
# Opsætning af en ny Hetzner-server (Ubuntu 24.04) til brixel.dk.
# Kør som root på den nye server:  bash opsaet-server.sh
# Caddy laver automatisk HTTPS-certifikat, når DNS for brixel.dk peger på serverens IP.
set -euo pipefail

DOMAENE="${DOMAENE:-brixel.dk}"
WEBROD="/var/www/brixel"

apt-get update
apt-get -y upgrade
apt-get -y install debian-keyring debian-archive-keyring apt-transport-https curl gnupg ufw unattended-upgrades

# Firewall: kun SSH, HTTP og HTTPS
ufw allow OpenSSH
ufw allow 80/tcp
ufw allow 443/tcp
ufw --force enable

# Automatiske sikkerhedsopdateringer
dpkg-reconfigure -f noninteractive unattended-upgrades

# Caddy (webserver med automatisk HTTPS)
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' > /etc/apt/sources.list.d/caddy-stable.list
apt-get update
apt-get -y install caddy

mkdir -p "$WEBROD"
if [ ! -f "$WEBROD/index.html" ]; then
  echo '<!doctype html><meta charset="utf-8"><title>brixel.dk</title><h1>brixel.dk kører igen</h1>' > "$WEBROD/index.html"
fi

cat > /etc/caddy/Caddyfile <<CADDY
$DOMAENE, www.$DOMAENE {
	root * $WEBROD
	encode gzip zstd
	file_server
	try_files {path} {path}/ /index.html
}
CADDY

systemctl reload caddy
echo "Færdig. Læg hjemmesidens filer i $WEBROD (fx med: scp -r ./* root@SERVER-IP:$WEBROD/)"
