#!/bin/bash

systemctl start docker

cd /home/kate/dockertest

docker-compose up

exit 0
