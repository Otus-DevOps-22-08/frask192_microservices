#!/bin/bash

cd /usr/local/src/

apt-get install -y git
git clone -b monolith https://github.com/express42/reddit.git

cd reddit && bundle install

cat << EOF > /etc/systemd/system/puma.service
[Unit]
Description=Puma OTUS reddit app
After=network.target
[Service]
Type=simple
WorkingDirectory=/usr/local/src/reddit
ExecStart=/usr/local/bin/puma
[Install]
WantedBy=multi-user.target
EOF

chmod 664 /etc/systemd/system/puma.service

systemctl daemon-reload

systemctl enable puma.service

systemctl start puma.service
