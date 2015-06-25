#!/bin/bash
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

source $DIR/containers.sh

stop_remove postgres
run_postgres

stop_remove backend
run_dev_backend

stop_remove webserver
run_dev_webserver
