Setup-Docker
=========

This role installs Weave-Net CNI to Kubernetes cluster.

Requirements
------------

The remote system should have Kubernetes Kubelet and APIServer and other master-components setup.

Role Variables
--------------

None

Dependencies
------------

* roles/bootstrap
* roles/kube-master
* roles/kube-worker

Example Playbook
----------------

```yaml
- name: Configure Kubernetes masters
  hosts: test-host
  gather_facts: true
  become: true
  roles:
    - role: cni
      tags: cni
```

License
-------

WTFPL

Author Information
------------------

Jaskaranbir Dhillon - Some random developer guy.
