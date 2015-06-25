#!/bin/bash
CONFDIR='./config'

source $CONFDIR/containers.sh

build_base

build_dev_backend

build_dev_webserver
