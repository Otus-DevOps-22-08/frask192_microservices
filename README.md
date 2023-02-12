# frask192_infra
frask192 Infra repository

####################################################################################
## HW 2
simple way
ssh -J user@ipA user@ipB or ssh -i /path/to/rsa/key -J user@ipA user@ipB

additional task

add at ~/.ssh/config

Host bastion
  Hostname ipA
  IdentityFile ~/.ssh/id_rsa
  User user

Host someinternalhost
  Hostname ipB
  ProxyJump user@ipA:22
  User user

ssh someinternalhost

https://en.wikibooks.org/wiki/OpenSSH/Cookbook/Proxies_and_Jump_Hosts

####################################################################################
## HW 3

bastion_IP = 51.250.68.255
someinternalhost_IP = 10.128.0.27

####################################################################################
## HW 4

testapp_IP = 51.250.68.119
testapp_port = 9292

install_ruby.sh - installing ruby and dependencies
install_mongodb.sh - installing bongodb and dependencies
deploy.sh - installing reddir app and dependencies

trouble - Err:7 https://repo.mongodb.org/apt/ubuntu xenial/mongodborg/4.2/multiverse amd64 Packages
  404  Not Found

  sudo apt-get install -y mongodb-org
Reading package lists... Done
Building dependency tree
Reading state information... Done
E: Unable to locate package mongodb-org

solution - echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.2.list

trouble - E: The method driver /usr/lib/apt/methods/https could not be found.
E: Failed to fetch https://repo.mongodb.org/apt/ubuntu/dists/xenial/mongodb-org/4.2/InRelease
E: Some index files failed to download. They have been ignored, or old ones used instead.

solution - sudo apt-get install -y apt-transport-https ca-certificates

####################################################################################
## HW 6

для запуска пакера с переменными в файле необходимо добавить -var-file="./variables.json" в команду запуска
packer build -var-file="./variables.json" ./immutable.json
сам variables.json внесен в .gitignor, его примером является variables.json.example
для запуски оброза с подготовленной средой и запуском по умолчанию puma.service создан скрипт congig-script/create-reddit-vm.sh

#########################################################################################
## HW 7

как создать сервисный аккаунт
https://cloud.yandex.ru/docs/iam/quickstart-sa
как создать ему ключ
https://cloud.yandex.com/en-ru/docs/iam/operations/iam-token/create-for-sa#keys-create

описал файл main.tf
файл outputs.tf используется для того, чтобы в конце apply вывести значения тех переменных, кторые мы там указали
variables.tf - описание переменных
сами переменных хранятся в terraform.tfvars
можно указать свой файл с переменным при помощи -var-file= или одну конкретную команду -var= в момент запуска terraform validate/apply

#########################################################################################
## HW 8

регистри, где лежат модули
https://registry.terraform.io/

#########################################################################################
## HW 9

Было настроено окружение для Ansible (python), создал и интвентори и конфиг файл.
ознакомились с базоывми командами ансибла для взаимодействия с ВМ, написали простой плейбук.

#########################################################################################
## HW 10

сделали плейбук для конфигрурации машин  app, db, добавили хендлеры, разбили один плейбук на несколько, заменили провиженер в Packer на Ansible. Собрали новые образы с изменным провиженером через Packer.

#########################################################################################
## HW 11

сделали окружение stage,prod, добавили community роль, jdauphant.nginx из ansible-galaxy, "повесили" приложение puma на 80 порт благодаря nginx. Сделали роль для добавления пользователей и зашифровали credntials при помощи vault.

#########################################################################################
## HW 12 ansible 4 vartamd molecule

перед началом использования необходимо выполнить "vagrand init", после чего скачать нуюный образ "vagrant box add ubuntu/xenial64" (образы лежат тут - https://app.vagrantup.com/boxes/search)
узнать какие образы скачены - "vagrant box list"
для определения сети, в какой работать VM
cat /etc/vbox/networks.conf
* 10.0.0.0/8
провиженеры vagrand - https://www.vagrantup.com/docs/provisioning
выполнить привеженинг для нужной ВМ - vagrant provision {{имя ВМ}}
удалить ВМ - "vagrant destroy -f"

перейти в директорию роли (roles/{{rolename}})
создать заготовку для тестов молекула --- molecule init scenario -r {{rolename}} --driver-name=vagrant
опсисать в roles/{{rolename}}/malecule/default/molecule.yml наши требования (в какой среде запускаем и чем)
запуск роли для приведения к нужному состоянию - molecule converge
запускаем проверку, получили мы то что хотели или нет - molecule verify

#########################################################################################
## HW 13 docer micro

docker rm $(docker ps -a -q) - удалить все не запущеные контейнеры
docker rmi $(docker images -q) - удалить все образы

docker logs reddit -f - поток логов контейнера
docker tag src dst - переименовать контейнер или сделать с тегом репозитория в который пушить

был создандокер образ с скриптом установки в нем монгоДБ, конфигов и сервиса puma
залил образ в свой репозиторий

#########################################################################################
## HW 14 docker network compose tests

docker network connect <network> <container> - подключить контейнер к сети
COMPOSE_PROJECT_NAME=OTUS - вот так в .env задается имя проекта

 создан docker-compose файл для сборки и запуска наших приложений

#########################################################################################
## HW 15 gitlab

yc compute instance create   --name gitlab-ci-vm   --zone ru-central1-a   --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4   --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1804-lts,size=50   --ssh-key ~/.ssh/id_rsa.pub  --memory=6G --cores=2 --core-fraction=20 --platform=standard-v3 --preemptible=true  ## делаем ВМ на ice lake, 20% процессорного времени и прерываемую для удешевления

docker-machine create  --driver generic  --generic-ip-address=IP --generic-ssh-user yc-user  --generic-ssh-key ~/.ssh/id_rsa  docker-host

sudo docker exec -it gitlab_web_1 grep 'Password:' /etc/gitlab/initial_root_password ### узнать root пароль из контейнера ранера

#########################################################################################
## HW 16 monitoring prometheus exporters

yc compute instance create   --name docker-host   --zone ru-central1-a   --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4   --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1804-lts,size=15   --ssh-key ~/.ssh/id_rsa.pub  --memory=5G --cores=2 --core-fraction=20 --platform=standard-v3 --preemptible=true

#########################################################################################
## HW 17 logging EFK Zipkin

yc compute instance create   --name logging   --zone ru-central1-a   --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4   --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1804-lts,size=15   --ssh-key ~/.ssh/id_rsa.pub  --memory=4G --cores=2 --core-fraction=20 --platform=standard-v3 --preemptible=true
