FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
    wget curl unzip build-essential zlib1g-dev libbz2-dev \
    liblzma-dev bedtools bash

RUN mkdir -p /opt/bedops && \
    cd /opt/bedops && \
    wget https://github.com/bedops/bedops/releases/download/v2.4.41/bedops_linux_x86_64-v2.4.41.tar.bz2 && \
    tar -xvjf bedops_linux_x86_64-v2.4.41.tar.bz2 && \
    cp bin/* /usr/local/bin/ && chmod +x /usr/local/bin/*

COPY gsh.sh /usr/local/bin/gsh.sh
RUN chmod 777 /usr/local/bin/gsh.sh

CMD ["/usr/local/bin/gsh.sh"]
