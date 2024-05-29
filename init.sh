#!/bin/bash

ARCH="amd64"
OS="linux"

CONTAINERD_VERSION="1.7.17"
RUNC_VERSION="1.1.12"
CNI_VERSION="1.5.0"
K8S_VERSION="1.30"

# Function to run a script and exit if it fails
run_script() {
    local script=$1
    echo "Running $script..."
    bash $script
    if [ $? -ne 0 ]; then
        echo "Error: $script failed. Exiting."
        exit 1
    fi
}

# List of scripts to run
scripts=("preflight.sh" "sys-util.sh" "install-containerd.sh" "install-kubeadm.sh")

# Run each script in the list
for script in "${scripts[@]}"; do
    run_script $script
done

echo "All scripts ran successfully."
