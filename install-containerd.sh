#!/bin/bash
set -e

# Environment Varaibles Below are setted in the init.sh
# If you want to run this script individually, please uncomment
# below lines and specify the related variables.

# ARCH="amd64"
# OS="linux"
# CONTAINERD_VERSION="1.7.17"
# RUNC_VERSION="1.1.12"
# CNI_VERSION="1.5.0"

# Allow user to override the default values
CONTAINERD_TAR=${1:-"containerd-$CONTAINERD_VERSION-$OS-$ARCH.tar.gz"}
CONTAINERD_URL=${2:-"https://github.com/containerd/containerd/releases/download/v$CONTAINERD_VERSION/$CONTAINERD_TAR"}
RUNC_BIN=${3:-"runc.$ARCH"}
RUNC_URL=${4:-"https://github.com/opencontainers/runc/releases/download/v$RUNC_VERSION/$RUNC_BIN"}
CNI_TAR=${5:-"cni-plugins-$OS-$ARCH-v$CNI_VERSION.tgz"}
CNI_URL=${6:-"https://github.com/containernetworking/plugins/releases/download/v$CNI_VERSION/$CNI_TAR"}
CONTAINERD_SERVICE_URL="https://raw.githubusercontent.com/containerd/containerd/main/containerd.service"

# Function to verify download with sha256sum
verify_sha256sum() {
    local file=$1
    local sha256=$2
    echo "$sha256 $file" | sha256sum -c -
    if [ $? -ne 0 ]; then
        echo "SHA256 checksum verification failed for $file"
        exit 1
    fi
}

# Step 1: Installing containerd
echo "Installing containerd..."
wget -q $CONTAINERD_URL -O $CONTAINERD_TAR
tar Cxzvf /usr/local $CONTAINERD_TAR
mkdir -p /usr/local/lib/systemd/system/
wget -q $CONTAINERD_SERVICE_URL -O /usr/local/lib/systemd/system/containerd.service
systemctl daemon-reload
systemctl enable --now containerd

# Step 2: Installing runc
echo "Installing runc..."
wget -q $RUNC_URL -O $RUNC_BIN
install -m 755 $RUNC_BIN /usr/local/sbin/runc

# Step 3: Installing CNI plugins
echo "Installing CNI plugins..."
mkdir -p /opt/cni/bin
wget -q $CNI_URL -O $CNI_TAR
tar Cxzvf /opt/cni/bin $CNI_TAR

echo "Installation completed successfully."
