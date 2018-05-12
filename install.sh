#!/bin/bash

echo "currently supported CPU platforms are as follows:"
echo "1) x86"
echo "2) x86_64"
echo "3) arm"
echo "4) arm64"
echo -n "please enter the corresponding number (1|2|3|4): "
read input
if [ "$input" = '1' ]; then
    arch="x86"
elif [ "$input" = '2' ]; then
    arch="x64"
elif [ "$input" = '3' ]; then
    arch="arm"
elif [ "$input" = '4' ]; then
    arch="arm64"
else
    echo "your input is wrong, please re-enter!" 1>&2
    exit 1
fi

cp -af tun2socks/tun2socks.$arch /usr/local/bin/tun2socks
cp -af chinadns/chinadns.$arch /usr/local/bin/chinadns
cp -af dnsforwarder/dnsforwarder.$arch /usr/local/bin/dnsforwarder
cp -af ss-tun2socks /usr/local/bin/
chmod 0755 /usr/local/bin/tun2socks
chmod 0755 /usr/local/bin/chinadns
chmod 0755 /usr/local/bin/dnsforwarder
chmod 0755 /usr/local/bin/ss-tun2socks

mkdir -p /etc/tun2socks/
cp -af ss-tun2socks.conf /etc/tun2socks/
cp -af ipset/chnroute.ipset /etc/tun2socks/
cp -af chinadns/chnroute.txt /etc/tun2socks/
cp -af dnsforwarder/dnsforwarder.conf /etc/tun2socks/

cp -af ss-tun2socks.service /etc/systemd/system/
systemctl daemon-reload

echo -n "start ss-tun2socks on boot with systemd? [y/N] "
read input
if [ "$input" = "y" -o "$input" = "Y" ]; then
    systemctl enable ss-tun2socks.service
fi

echo -n "edit /etc/tun2socks/ss-tun2socks.conf? [y/N] "
read input
if [ "$input" = "y" -o "$input" = "Y" ]; then
    vim /etc/tun2socks/ss-tun2socks.conf
    echo -n "start ss-tun2socks service now? [y/N] "
    read input
    if [ "$input" = "y" -o "$input" = "Y" ]; then
        /usr/local/bin/ss-tun2socks start
    fi
fi
