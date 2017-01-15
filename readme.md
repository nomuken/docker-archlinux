1日おきにアップデートされるArch LinuxのDockerイメージです。

Update : D1

[![Build Status](https://travis-ci.org/ArchLinuxJP/docker-archlinux.svg?branch=master)](https://travis-ci.org/ArchLinuxJP/docker-archlinux)

```bash
$ sudo docker pull archlinuxjp/archlinux
$ sudo docker run -it archlinuxjp/archlinux /bin/bash
```

このArch Linuxの Dockerイメージは、[docker/docker](https://github.com/docker/docker/blob/master/contrib/mkimage-arch.sh)のスクリプトを使用して作成されています。イメージの作成方法は`Step 1`になります。これは既存のArch Linux上で実行されました。

## Step 1

```bash
$ systemctl start docker
$ pacman -Sy expect arch-install-scripts --noconfirm
$ curl -sLO https://raw.githubusercontent.com/docker/docker/master/contrib/mkimage-arch-pacman.conf -O https://raw.githubusercontent.com/docker/docker/master/contrib/mkimage-arch.sh -O https://github.com/docker/docker/blob/master/contrib/mkimage-archarm-pacman.conf 
$ chmod +x mkimage-arch.sh
$ vim mkimage-arch.sh
DOCKER_IMAGE_NAME=$USER/$REPO

$ ./mkimage-arch.sh

$ docker run -it $USER/$REPO /bin/bash
# :
# pacman -Sy archlinux-keyring --noconfirm
# pacman-key --refresh-keys
# pacman -Sy --noconfirm
# pacman-db-upgrade
# trust extract-compat
# exit

$ docker push $USER/$REPO
```

## Step 2

`Step 2`ではDockerイメージを更新する手続きについて記述します。具体的には`Travis-CI`の`Cron Jobs`機能を使ってイメージを更新します。これは、1日おきにDockerイメージを`pacman -Syu`してDocker Hubに`Push`する内容になっています。ただし、当該更新手順は予告なく変更される可能性があります。

update : travis-ci($USER/$REPO) -> cron jobs -> d1

> .travis.yml

```bash
language: $LANG
sudo: required
services:
  - docker

env:
  - TARGET_CONTAINER_ID=container-$REPO


script:
  - docker build -t $USER/$REPO .

after_success:
  - if [ "$TRAVIS_BRANCH" == "master" ]; then
        docker login -e="$DOCKER_EMAIL" -u="$DOCKER_USERNAME" -p="$DOCKER_PASSWORD";
        docker push $USER/$REPO;
    fi
```

## Other

その他、公式スクリプト`mkimage-arch.sh`によって作成されたDockerイメージを`.tar.gz`の形式にエクスポートしたり、それをイメージにインポートする方法は下記の通りです。

```bash
$ ./mkimage-arch.sh
```

```bash
$ docker save $USER/$REPO > archlinux.tar.gz
$ tar -c . | docker import - $USER/$REPO
$ docker run -it $USER/$REPO /bin/bash
# :
# pacman -Sy archlinux-keyring --noconfirm
# pacman-key --refresh-keys
# pacman -Sy --noconfirm
# pacman-db-upgrade
# trust extract-compat
# exit

$ docker push $USER/$REPO
```

or 

> Dockerfile

```base
FROM scratch
ADD archlinux.tar.gz /
```

```bash
$ docker build -t $USER/$REPO .
$ docker run -it $USER/$REPO /bin/bash
# :
# pacman -Sy archlinux-keyring --noconfirm
# pacman-key --refresh-keys
# pacman -Sy --noconfirm
# pacman-db-upgrade
# trust extract-compat
# exit

$ docker psuh $USER/$REPO
```
