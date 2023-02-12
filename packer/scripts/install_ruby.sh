#!/bin/bash

echo "##############################################"
echo "INSTALL ruby-full ruby-bundler build-essential"
echo "##############################################"

sudo apt update
sleep 3
sudo apt install -y ruby-full ruby-bundler build-essential
