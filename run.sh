#!/usr/bin/bash
echo "Starting up..."

pip install ptftpd

firewall-cmd --add-service=tftp --permanent
firewall-cmd --add-port=8080/tcp --permanent
firewall-cmd --add-service=dhcp --permanent
firewall-cmd --reload

trap killgroup SIGINT

killgroup(){
  echo Killing...
  kill 0
}

pxed -g 10.2.0.1 -v -D ens18 `readlink -e ./tftproot` lpxelinux.0 &
cd httproot; python -m SimpleHTTPServer 8080 &

wait
