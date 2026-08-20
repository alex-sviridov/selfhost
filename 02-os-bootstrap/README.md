# Bootstrapping and OS maintenance

Configures base OS settings, deploys the K3s cluster, and handles rolling updates and patch management via Ansible.

## Prerequisites

- ansible
- python3
- kubectl

```bash
make install
```

## Day-1: Configuration Management / Bootstrapping

```bash
make provision
make k3s-kubeconfig-get
export KUBECONFIG=~/.kube/selfhost-config
```

## Day-2: Maintenance

```bash
make os-upgrade # Regular OS\packages update and reboot

make k3s-upgrade # Upgrade k3s version according to group_vars/k3s_cluster.yml:k3s_version
```