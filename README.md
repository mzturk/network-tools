# network-tools
# Debian Static IP Setup Script

Bu repo, **Debian sunucularda tek seferlik statik IP ayarı** yapmak için hazırlanmış bir bash script içerir.  
Script, `/etc/network/interfaces` dosyasını doğrudan düzenler ve ağı yeniden başlatır.

---

## Özellikler
- Eski `/etc/network/interfaces` dosyasını otomatik yedekler.
- DHCP yerine statik IP yapılandırması yazar.
- Tek seferlik çalışır (otomatik kurulum gibi sürekli güncelleme yapmaz).
- Ağ servislerini yeniden başlatır ve yeni IP bilgilerini gösterir.

---

## Kullanım

1. Script’i repo’ya ekle (örnek: `install_static_ip.sh`).
2. Sunucuda indir ve çalıştırılabilir hale getir:
   ```bash
   chmod +x install_static_ip.sh
Statik IP’yi ayarla:

bash
Kodu kopyala
sudo ./install_static_ip.sh <interface> <ip_address> <netmask> <gateway> <dns1[,dns2,...]>
Örnek
bash
Kodu kopyala
sudo ./install_static_ip.sh enp2s0 192.168.1.100 255.255.255.0 192.168.1.1 8.8.8.8
Bu komut, enp2s0 arayüzüne şu ayarları uygular:

IP: 192.168.1.100

Netmask: 255.255.255.0

Gateway: 192.168.1.1

DNS: 8.8.8.8

Notlar
Uygulama sonrası SSH bağlantın kesilebilir (özellikle uzak sunucularda). Konsol erişimin varsa oradan denemen daha güvenlidir.

Tekrar DHCP’ye dönmek için /etc/network/interfaces dosyasındaki ilgili kısmı manuel olarak dhcp yapabilirsin veya yedek dosyayı geri yükleyebilirsin:

bash
Kodu kopyala
sudo cp /etc/network/interfaces.bak.TARIH /etc/network/interfaces
sudo systemctl restart networking

1. SSH ile sunucuya bağlan
ssh KULLANICI_ADI@SUNUCU_IP

2. Script’i indir
wget https://raw.githubusercontent.com/mzturk/network-tools/main/set_static_ip.sh -O set_static_ip.sh


Alternatif:

curl -o set_static_ip.sh https://raw.githubusercontent.com/mzturk/network-tools/main/set_static_ip.sh

3. Çalıştırılabilir hale getir
chmod +x set_static_ip.sh

4. Script’i çalıştır

Örnek:

sudo ./set_static_ip.sh enp2s0 192.168.1.100 255.255.255.0 192.168.1.1 8.8.8.8

5. Doğrula
ip addr show enp2s0
ip route
cat /etc/network/interfaces


⚠️ Uyarı:
Bunu uzaktan (SSH) yapıyorsan ve yanlış IP/gateway girersen bağlantın düşebilir. O yüzden:

Önce aynı subnet’ten doğru IP seçtiğine emin ol.

Mümkünse konsol erişimi (örneğin sanal sunucularda panelden) yedek olsun.
