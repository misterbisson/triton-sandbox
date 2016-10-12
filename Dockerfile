FROM ubuntu:16.04

# Docker remote API connection vars
ENV DOCKER_CERT_PATH=/root/.supervisor/docker/
ENV DOCKER_TLS_VERIFY=1
ENV COMPOSE_HTTP_TIMEOUT=300

# Get some packages, Docker, and Docker Compose
RUN set -ex \
    && apt-get update && apt-get install -y --no-install-recommends \
        apt-transport-https \
        ca-certificates \
        curl \
        dnsutils \
        git \
        htop \
        less \
        nodejs \
        npm \
        ssh \
        unzip \
        vim \
    # \
    # Link Node.js to the expected name
    && ln -s /usr/bin/nodejs /usr/bin/node \
    # \
    # Add Docker repos
    && apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D \
    && echo deb https://apt.dockerproject.org/repo ubuntu-xenial main > /etc/apt/sources.list.d/docker.list \
    # \
    # Install Docker \
    && apt-get update && apt-get install -y --no-install-recommends \
        docker-engine \
    # \
    # Clean up after apt \
    && rm -rf /var/lib/apt/lists/* \
    # \
    # Install Compose \
    && curl -L https://github.com/docker/compose/releases/download/1.7.1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose \
    # \
    # Install Triton CLI and related tools \
    && npm install -g triton manta json \
    # \
    # Install gotty, for web-terminal, https://github.com/yudai/gotty \
    && export GOTTY_VERSION=v0.0.13 \
    && export GOTTY_CHECKSUM=6c5ac6e878f7c79cfe6e1b394be00d67e6165c80e94debf0767ce2da47224266 \
    && export archive=gotty_linux_amd64.tar.gz \
    && curl -Lso /tmp/${archive} https://github.com/yudai/gotty/releases/download/${GOTTY_VERSION}/${archive} \
    && echo "${GOTTY_CHECKSUM}  /tmp/${archive}" | sha256sum -c \
    && cd /bin \
    && tar zxvf /tmp/${archive} \
    && chmod +x /bin/gotty \
    && rm /tmp/${archive} \
    # \
    # Fetch some demo repos \
    && mkdir /demo \
    && cd /demo \
    && git clone https://github.com/autopilotpattern/elk.git \
    && git clone https://github.com/autopilotpattern/hello-world.git \
    && git clone https://github.com/autopilotpattern/wordpress.git \
    && git clone https://github.com/autopilotpattern/workshop.git \
    && git clone https://github.com/joyent/mesos-dockerfiles.git

WORKDIR /demo

# Build meta and Docker labels
ARG BUILD_DATE
ARG BRANCH
LABEL com.joyent.build-date=$BUILD_DATE \
    com.joyent.branch=$BRANCH

# On macOS, with SSH keys and a Triton config in expected places
# docker run --rm -it -v ~/.ssh:/root/.ssh -v ~/.triton:/root/.triton triton-sandbox bash

