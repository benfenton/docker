FROM ubuntu:14.04
MAINTAINER Artem Golub <artemgolub@gmail.com>

# Update package list, upgrade
# Install python-pip
# Clean up APT when done
RUN apt-get update && \
    apt-get -y -q upgrade && \
    apt-get install --no-install-recommends -q -y \
        python \
        python-pip \
        uwsgi-plugin-python \
        git \
        openssh-server \
        openssh-sftp-server \
        nginx && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
