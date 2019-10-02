#!/usr/local/bin/zsh

#reset any custom DNS
networksetup -setdnsservers 'Wi-Fi' Empty
networksetup -setdnsservers 'Thunderbolt' Empty

currentDNS=$(awk '/^nameserver/ {print $2;exit}' /etc/resolv.conf)
echo 'changing dnsmasq.conf'
sed -i -e "/^server=[^/]/s/=.*$/=$currentDNS/" /usr/local/etc/dnsmasq.conf && \
/usr/local/bin/brew services restart dnsmasq

thunderbolt_if=$(networksetup -listnetworkserviceorder | egrep 'Hardware.*Thunderbolt.*Device:' | egrep -o 'en[0-9]')
get_active() {
  tb_status=$( (ifconfig $thunderbolt_if | egrep -o 'status:.*') || echo 'false' )
  if [ "$tb_status" = false ]; then
    echo 'Wi-Fi'
  else
    echo 'Thunderbolt'
  fi
}

active_dev=$(get_active)
networksetup -setdnsservers $active_dev '127.0.0.1'
echo "changed DNS to local dnsmasq on $active_dev"
