#!/bin/bash

set -eu

sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config.d/50-cloud-init.conf

sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/^#*PermitEmptyPasswords.*/PermitEmptyPasswords no/' /etc/ssh/sshd_config
sed -i 's/^#*PubkeyAuthentication.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config

sudo systemctl reload ssh

curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sudo sh -s -- -b /usr/local/bin

sudo cp -r /vagrant/* /home/vagrant

if [[ "$HOSTNAME" == "app1" ]]; then
    sudo sed -i 's/^#*DefaultEnvironment.*/DefaultEnvironment="BIRD_PHOTO=photo1" "BIRD_NAME=Ara" "LOCATION=Rio"/' /etc/systemd/system.conf
else
    sudo sed -i 's/^#*DefaultEnvironment.*/DefaultEnvironment="BIRD_PHOTO=photo2" "BIRD_NAME=Owl" "LOCATION=Hogwarts"/' /etc/systemd/system.conf
fi

sudo apt-get update

sudo apt-get -y install python3
sudo apt-get -y install python3-packaging
sudo apt-get -y install python3-pip
sudo apt-get -y install python3.12-venv
sudo apt-get -y install nginx

sudo chown vagrant /home/vagrant/BirdWatchingApp

sudo chmod 755 /home/vagrant
sudo chmod -R 755 /home/vagrant/BirdWatchingApp

python3 -m venv /home/vagrant/BirdWatchingApp/venv1
source /home/vagrant/BirdWatchingApp/venv1/bin/activate
cd /home/vagrant/BirdWatchingApp
python3 -m pip install --upgrade pip
pip install -r requirements.txt
deactivate


sudo cp /home/vagrant/Scripts/BirdWatching.service /etc/systemd/system
sudo systemctl daemon-reload
sudo systemctl enable BirdWatching.service
sudo systemctl start BirdWatching.service


sudo cp /home/vagrant/Scripts/rp_template /etc/nginx/sites-available
sudo ln -sf /etc/nginx/sites-available/rp_template /etc/nginx/sites-enabled/

if [ -f "/etc/nginx/sites-enabled/default" ]; then
    sudo rm /etc/nginx/sites-enabled/default
fi

sudo systemctl restart nginx
