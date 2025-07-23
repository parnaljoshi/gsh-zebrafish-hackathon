#!/bin/bash

set -e

echo "Updating package lists..."
sudo apt-get update

echo "Installing required system packages..."
sudo apt-get install -y \
    bedtools \
    coreutils \
    less \
    wget \
    curl \
    git \
    gawk \
    grep \
    python3 \
    python3-pip \
    tar \
    bzip2

# Optional but useful
echo "Installing BEDOPS (for gtf2bed)..."
BEDOPS_VERSION="v2.4.41"
BEDOPS_ARCHIVE="bedops_linux_x86_64-${BEDOPS_VERSION}.tar.bz2"
wget https://github.com/bedops/bedops/releases/download/${BEDOPS_VERSION}/${BEDOPS_ARCHIVE}
tar -xvjf ${BEDOPS_ARCHIVE}
sudo cp bin/* /usr/local/bin/
rm -rf bedops* ${BEDOPS_ARCHIVE}

# Confirm gtf2bed is working
if ! command -v gtf2bed &> /dev/null; then
    echo "gtf2bed is not installed correctly!"
    exit 1
else
    echo "gtf2bed installed."
fi

echo "All dependencies are installed and ready!"
