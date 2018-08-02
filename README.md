# Kubeadm Ansible Playbook
---

Quickly bootstrap a Kubernetes cluster via Kubeadm using this Playbook.

System Requirements:

* Required Ansible version: 2.6+
* Passwordless SSH access for all nodes
* Currently targetted for Ubuntu 16.04 (can be adapted to other distros)
* 4GB RAM (6GB if running via Vagrant/VM) with a dual-core processor minimum recommended

Environment Info:

* Kubernetes version: 1.11.1
* CNI: Weave-Net
* Default number of nodes: 1

## Usage:

---

### Vagrant:

* Install [VirtualBox][0] and [Vagrant][1].

* Run `vagrant up`. This will automatically provision a VM with a single-node Kubernetes cluster installed with some addons (check below).

### Manual Installation

* Add the system-node information to the `inventory/hosts.yml` file. For example:

```YAML
all:
  children:

    kubernetes:
      children:

        kubernetes-masters:
          hosts:
            kube-master-01:
```

* Edit `group_vars/all.yml` and other role-specific variables (under `roles/<role-name>/default/main.yml`) as required.

* Run the `kubernetes.yaml` playbook with privileges.  
  **Note**: Since Ansible 2.6+, it is required that the private_key must have permissions `400`, and the ansible-files should reside in a non-public directory (permissions `744`).

  ```Bash
  sudo ansible-playbook kubernetes.yaml
  ```

#### Getting the Kubeconfig for Kubectl

* Copy file `/etc/kubernetes/admin.conf` to `~/.kube/config`. This will allow Kubectl to connect and operate on this node.

  Within the Vagrant VM, all this has already been setup.

### Namespaces

The role installs additional three namespaces by default:

* Development
* Staging
* Production

To not install these namespaces, disable the *Setup Namespaces* step in `roles/addons/tasks/main.yml`.
**Note**: A lot of addons depend on these namespaces to be present, so you'll have to make changes to addon-installation tasks too.

### Addons

The playbook install following addons by default:

* Helm/Tillar
* Nginx Ingress (Internal Services)
* Nginx Ingress (External Services)
* Prometheus
* Grafana (includes a dashboard, using Prometheus as DataSource)
* The default Kubeadm addons (such as Dashboard)

If you would prefer not to install these addons, comment-out/delete the relavant lines in `kubernetes.yaml` file. For example, to disable addons:

```YAML
# - name: Setup Kubernetes addons
#   hosts: kube-master-01
#   gather_facts: true
#   become: true
#   roles:
#     - role: addons
#       tags: addons
```

### The Nginx-Ingress Addons

* By default, the internal Nginx-Ingress is exposed via NodePorts, while the external Nginx-Ingress uses HostNetwork. This can be configured in the addons role: `roles/addons/templates`

* Check the addon-templates to know more about how the Ingress services are created: `roles/addons/templates`.

### Security

This is intended to be just a basic setup, and as such, the security is very basic.  
With Kubernetes providing vast security options, the user is expected to go through the setup and customize options such as security (and especially security) as per requirements.

  [0]: https://www.virtualbox.org/
  [1]: https://www.vagrantup.com/
