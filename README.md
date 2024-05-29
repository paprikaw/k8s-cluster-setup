# k8s-cluster-setup
This repository includes minimul setup scripts to initialize a node before executing `kubeadm init` or `join`.

```
├── init.sh: The main script to run
├── install-containerd.sh: install containerd
├── install-kubeadm.sh: install kubeadm
├── preflight.sh: preflight check script
└── sys-util.sh: Open the neccessary system utilities for kubernetes.
```

# Usage
Running the following command as root user:

``` sh
./init.sh
```