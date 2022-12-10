#!/usr/bin/env bash
set -euo pipefail

# install apt-add-repository
apt update 
apt install software-properties-common -y
apt update

# install dotnet-sdk
apt-get update
apt-get install -y dotnet-sdk-6.0

# install dotnet-runtime
apt-get update
apt-get install -y aspnetcore-runtime-6.0

# install postgresql
apt-get update
apt-get install -y postgresql postgresql-contrib
sudo service postgresql start
sudo -u postgres psql -c "ALTER user postgres WITH PASSWORD 'postgres'"

# install redis
# curl -fsSL https://packages.redis.io/gpg | sudo gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg
# echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/redis.list
sudo apt-get update
sudo apt-get -y install redis

# install rabbitMQ
apt-get install curl gnupg apt-transport-https -y
curl -1sLf "https://keys.openpgp.org/vks/v1/by-fingerprint/0A9AF2115F4687BD29803A206B73A36E6026DFCA" | sudo gpg --dearmor | sudo tee /usr/share/keyrings/com.rabbitmq.team.gpg > /dev/null
curl -1sLf "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0xf77f1eda57ebb1cc" | sudo gpg --dearmor | sudo tee /usr/share/keyrings/net.launchpad.ppa.rabbitmq.erlang.gpg > /dev/null
curl -1sLf "https://packagecloud.io/rabbitmq/rabbitmq-server/gpgkey" | sudo gpg --dearmor | sudo tee /usr/share/keyrings/io.packagecloud.rabbitmq.gpg > /dev/null
apt-get update -y
apt-get install -y erlang-base \
    erlang-asn1 erlang-crypto erlang-eldap erlang-ftp erlang-inets \
    erlang-mnesia erlang-os-mon erlang-parsetools erlang-public-key \
    erlang-runtime-tools erlang-snmp erlang-ssl \
    erlang-syntax-tools erlang-tftp erlang-tools erlang-xmerl
apt-get install rabbitmq-server -y

# install nodejs
apt-get update
curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt-get -y install nodejs

# install yarn
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update && sudo apt -y install yarn

# echo "Adding HashiCorp GPG key and repo..."
# curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
# apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
# apt-get update

# install cni plugins https://www.nomadproject.io/docs/integrations/consul-connect#cni-plugins
# echo "Installing cni plugins..."
# curl -L -o cni-plugins.tgz "https://github.com/containernetworking/plugins/releases/download/v1.1.1/cni-plugins-linux-$( [ $(uname -m) = aarch64 ] && echo arm64 || echo amd64)"-v1.1.1.tgz
# sudo mkdir -p /opt/cni/bin
# sudo tar -C /opt/cni/bin -xzf cni-plugins.tgz
# sudo rm ./cni-plugins.tgz

# echo "Installing Consul..."
# sudo apt-get install consul=1.12.2-1 -y

# echo "Installing Nomad..."
# sudo apt-get install nomad=1.3.1-1 -y

# echo "Installing Vault..."
# sudo apt-get install vault=1.11.0-1 -y

# # configuring environment
# sudo -H -u root nomad -autocomplete-install
# sudo -H -u root consul -autocomplete-install
# sudo -H -u root vault -autocomplete-install
# sudo tee -a /etc/environment <<EOF
# export VAULT_ADDR=http://localhost:8200
# export VAULT_TOKEN=root
# EOF

source /etc/environment

# nomad cannot run on wsl2 image, then we need to work-around
sudo mkdir -p /lib/modules/$(uname -r)/
echo '_/bridge.ko' | sudo tee -a /lib/modules/$(uname -r)/modules.builtin