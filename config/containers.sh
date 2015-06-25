#!/bin/bash

# set -o xtrace (Show verbose command output for debugging.)
# set +o xtrace (To revert to normal.)

SCRIPTPATH=`pwd -P`
CONFDIR=$SCRIPTPATH
ROOTDIR=`dirname $CONFDIR`

REGISTRY="agolub"

VER_BASE="latest"
VER_DEV_BACKEND="latest"
VER_DEV_WEBSERVER="latest"


build() {
    cd $CONFDIR/docker-$1
    docker build -t $REGISTRY/$1:$2 .

    rm -rf $CONFDIR/docker-$1/requirements
    cd $CONFDIR
}


#--------------------------------------------------------------------------------#
# Base image that has all our needed software, but does not run anything.
#--------------------------------------------------------------------------------#

build_base() {
    NAME=base
    VERSION=$VER_BASE

    build $NAME $VERSION
}


#--------------------------------------------------------------------------------#
# Development related build scripts.
#--------------------------------------------------------------------------------#

build_dev_backend() {
    NAME=backend
    VERSION=$VER_DEV_BACKEND

    sed -i 's/:VER_BASE/:'"$VER_BASE"'/g' $CONFDIR/docker-$NAME/Dockerfile
    build $NAME $VERSION
    sed -i 's/:'"$VER_BASE"'/:VER_BASE/g' $CONFDIR/docker-$NAME/Dockerfile
}

build_dev_webserver() {
    NAME=webserver
    VERSION=$VER_DEV_WEBSERVER

    sed -i 's/:VER_BASE/:'"$VER_BASE"'/g' $CONFDIR/docker-$NAME/Dockerfile
    build $NAME $VERSION
    sed -i 's/:'"$VER_BASE"'/:VER_BASE/g' $CONFDIR/docker-$NAME/Dockerfile
}


#--------------------------------------------------------------------------------#
# Development related Docker run scripts.
#--------------------------------------------------------------------------------#

run_postgres() {
    docker run --name postgres -e POSTGRES_PASSWORD=postgres -d postgres
}

run_dev_backend() {
    NAME=backend

    mkdir -p $ROOTDIR/logs

    docker run \
        --link postgres:postgres \
        -v $ROOTDIR/app:/app \
        -v $ROOTDIR/logs:/logs \
        -d \
        -h $NAME \
        -p 9000:9000 \
        --name $NAME \
        $REGISTRY/backend:$VER_DEV_BACKEND
}

run_dev_webserver() {
    NAME=webserver

    docker run \
        --link backend:backend \
        --volumes-from backend \
        --name $NAME \
        -d \
        -p 80:80 \
        $REGISTRY/webserver:$VER_DEV_WEBSERVER
}

stop_remove() {
    # @param $1: name of container to stop and remove
    if [ `docker ps | grep $1 | wc -l` -ne 0 ]; then
        docker stop $1
    fi
    if [ `docker ps -a | grep $1 | wc -l` -ne 0 ]; then
        docker rm $1
    fi
    sleep 2
}
