Setup-Docker
=========

This role sets up Kubernetes Master node. This also installs three additional namespaces:

* Development
* Staging
* Production

Requirements
------------

The remote system should have **Docker**, **Kubelet**, **Kubeadm**, and **Kubectl** installed.

Role Variables
--------------

**kubeadm_opts**: Arguments to pass to Kubeadm.

**service_subnet**: The service-subnet base IP. For example: `10.0.96`.
**service_cidr**: The CIDR for `service_subnet`. For example: `0/12`.
**dns_name**: DNS name for the cluster.
**dns_ip**: The DNS-IP for cluster. For example: `service_subnet + .10`.
**pod_network_cidr**: CIDR for pod-network. For Example: `10.244.0.0/16`.

**ansible_templates_dir**: Directory where templates for the role exist.
**kubeadmin_config**: The Kubeconfig template for admin, having admin-cluster-rights.
**kube_namespace_dir**: Directory containing manifests for cluster Namespaces.
**kube_persistent_volumes_dir**: Directory containing manifests for cluster Persistent-Volumes.

Dependencies
------------

* roles/bootstrap
* roles/cni

Example Playbook
----------------

```yaml
- name: Configure Kubernetes masters
  hosts: test-hosts
  gather_facts: true
  become: true
  roles:
    - role: kube-master
      tags: kube-master
    - role: cni
      tags: cni
```

License
-------

WTFPL

Author Information
------------------

Jaskaranbir Dhillon - Some random developer guy.
