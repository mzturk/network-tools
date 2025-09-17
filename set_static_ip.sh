#!/bin/bash
# Debian - /etc/network/interfaces kullanarak statik IP ayarlama
# Kullanım:
# sudo ./set_static_ip.sh <interface> <ip_address> <netmask> <gateway> <dns1[,dns2,...]>

set -e

if [ "$EUID" -ne 0 ]; then
  echo "❌ Bu script root yetkisiyle çalıştırılmalı (sudo)."
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

# Dosyanın yedeğini al
BACKUP="/etc/network/interfaces.bak.$(date +%Y%m%d%H%M%S)"
cp /etc/network/interfaces "$BACKUP"
echo "✅ Yedek alındı: $BACKUP"

# Yeni ayarları yaz
cat <<EOF > /etc/network/interfaces
# Bu dosya otomatik olarak oluşturuldu: $(date)

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

echo "✅ /etc/network/interfaces güncellendi."

# Ağ servislerini yeniden başlat
systemctl restart networking || service networking restart

echo ">>> Yeni IP bilgisi:"
ip addr show dev "$IFACE"
