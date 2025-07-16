# Base image
FROM ubuntu:22.04
# Avoiding interactive prompts
ENV DEBIAN_FRONTEND=noninteractive
# Install system and bioinformatics dependencies
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    git \
    unzip \
    python3 \
    python3-pip \
    bedtools \
    gawk \
    sed \
    grep \
    build-essential \
    zlib1g-dev \
    libncurses5-dev \
    libbz2-dev \
    liblzma-dev \
    libcurl4-gnutls-dev \
    libssl-dev \
    && apt-get clean
# Copy all project files (including gsh.sh) into /opt/gsh
COPY . /gsh
COPY gsh.sh /gsh
# Install BEDOPS for gtf2bed, convert2bed, etc.
RUN wget -O /gsh/bedops.tar.bz2 https://github.com/bedops/bedops/releases/download/v2.4.41/bedops_linux_x86_64-v2.4.41.tar.bz2 && \
    cd /gsh && \
    tar -xvjf bedops.tar.bz2 && \
    cp bin/* /usr/local/bin/ && \
    rm -rf bin bedops.tar.bz2
# Make sure main script is executable
RUN chmod 777 /gsh/gsh.sh
# Set entrypoint using full path
CMD ["bash", "/gsh/gsh.sh"]
