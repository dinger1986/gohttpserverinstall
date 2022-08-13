# gohttpserverinstall
Easy install Script for gohttpserver on linux, should work on any debian or centos based system supporting systemd. https://github.com/codeskyblue/gohttpserver

Creates a directory under /opt/gohttp/public for files to sit in

You can use Hetzner to test this with a $20 credit using this referal code https://hetzner.cloud/?ref=p6iUr7jEXmoB

# How to Install the server
Please setup your firewall on your server prior to running the script.

Make sure you have got access via ssh or otherwise setup prior setting up the firewall, command for UFW is.
```
ufw allow proto tcp from YOURIP to any port 22
```

If you have UFW installed use the following commands:
```
ufw allow 8000/tcp
sudo ufw enable
```

Run the following commands:
```
wget https://raw.githubusercontent.com/dinger1986/gohttpserverinstall/main/install.sh
chmod +x install.sh
./install.sh
```

