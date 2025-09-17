#!/bin/bash
# Debian - GitHub'dan statik IP ayarı (tek seferlik)

set -e

if [ "$EUID" -ne 0 ]; then
  echo "❌ Root (sudo) yetkisiyle çalıştırılmalı."
  exit 1
fi

if [ $# -lt 5 ]; then
  echo "Kullanım: $0 <interface> <ip_address> <netmask> <gateway> <dns1[,dns2,...]>"
  echo "Örnek:   $0 enp2s0 192.168.1.100 255.255.255.0 192.168.1.1 8.8.8.8,1.1.1.1"
  exit 1
fi

IFACE=$1
IPADDR=$2
NETMASK=$3
GATEWAY=$4
DNS=$5

# Eski dosyayı yedekle
BACKUP="/etc/network/interfaces.bak.$(date +%Y%m%d%H%M%S)"
cp /etc/network/interfaces "$BACKUP"
echo "✅ /etc/network/interfaces yedeklendi: $BACKUP"

# Yeni konfigürasyonu yaz
cat <<EOF > /etc/network/interfaces
# /etc/network/interfaces - otomatik oluşturuldu: $(date)

source /etc/network/interfaces.d/*

auto lo
iface lo inet loopback

auto $IFACE
iface $IFACE inet static
    address $IPADDR
    netmask $NETMASK
    gateway $GATEWAY
    dns-nameservers $DNS
EOF

echo "✅ Yeni /etc/network/interfaces yazıldı."

# Ağ servisini yeniden başlat
echo "🔄 Ağ yeniden başlatılıyor..."
systemctl restart networking || service networking restart

echo ">>> IP bilgisi:"
ip addr show dev "$IFACE"
ip route show
