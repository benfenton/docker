#!/bin/bash
CONFDIR='./config'

source $CONFDIR/containers.sh

stop_remove postgres
run_postgres

stop_remove backend
run_dev_backend

stop_remove webserver
run_dev_webserver
