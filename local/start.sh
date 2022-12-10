#!/usr/bin/env bash

echo 'Starting postgres...'
sudo service postgresql start

echo 'Starting redis-server'
sudo service redis-server start

echo 'Starting rabbit-mq'
sudo service rabbitmq-server start
sudo rabbitmq-plugins enable rabbitmq_management
sudo rabbitmqctl add_user khanhnd 123456aA@
sudo rabbitmqctl set_user_tags khanhnd administrator
sudo rabbitmqctl set_permissions -p / khanhnd ".*" ".*" ".*"