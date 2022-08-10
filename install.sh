#!/bin/bash

# Get Username
uname=$(whoami)
admintoken=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c16)

# Download and install gohttpserver
mkdir /opt/gohttp
mkdir /opt/gohttp/public
sudo chown "${uname}" -R /opt/gohttp
cd /opt/gohttp
GOHTTPLATEST=$(curl https://api.github.com/repos/codeskyblue/gohttpserver/releases/latest -s | grep "tag_name"| awk '{print substr($2, 2, length($2)-3) }')
wget https://github.com/codeskyblue/gohttpserver/releases/download/${GOHTTPLATEST}/gohttpserver_${GOHTTPLATEST}_linux_amd64.tar.gz
tar -xf gohttpserver_${GOHTTPLATEST}_linux_amd64.tar.gz
rm -rf gohttpserver_${GOHTTPLATEST}_linux_amd64.tar.gz

# Make gohttp log folders
mkdir /var/log/gohttp/
sudo chown "${uname}" -R /var/log/gohttp/

# Setup Systemd to launch Go HTTP Server
gohttpserver="$(cat << EOF
[Unit]
Description=Go HTTP Server
[Service]
Type=simple
LimitNOFILE=1000000
ExecStart=/opt/gohttp/gohttpserver -r ./public --port 8000 --auth-type http --auth-http admin:${admintoken}
WorkingDirectory=/opt/gohttp/
User=${uname}
Group=${uname}
Restart=always
StandardOutput=append:/var/log/gohttp/gohttpserver.log
StandardError=append:/var/log/gohttp/gohttpserver.error
# Restart service after 10 seconds if node service crashes
RestartSec=10
[Install]
WantedBy=multi-user.target
EOF
)"
echo "${gohttpserver}" | sudo tee /etc/systemd/system/gohttpserver.service > /dev/null
sudo systemctl daemon-reload
sudo systemctl enable gohttpserver.service
sudo systemctl start gohttpserver.service


echo -e "You can access your gohttpserver by going to http://${wanip}:8000"
echo -e "Username is admin and password is ${admintoken}"

echo "Press any key to finish install"
while [ true ] ; do
read -t 3 -n 1
if [ $? = 0 ] ; then
exit ;
else
echo "waiting for the keypress"
fi
done
