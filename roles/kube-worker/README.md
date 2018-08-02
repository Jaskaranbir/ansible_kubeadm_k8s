Setup-Docker
=========

This role sets up Kubernetes Worker node.

Requirements
------------

The remote system should have Kubernetes Master setup.

Role Variables
--------------

None

Dependencies
------------

* roles/bootstrap
* roles/kube-master
* roles/cni

Example Playbook
----------------

```yaml
- name: Configure Kubernetes workers
  hosts: test-hosts
  gather_facts: true
  become: true
  roles:
    - role: kube-worker
      tags: worker
    - role: cni
      tags: cni
```

License
-------

WTFPL

Author Information
------------------

Jaskaranbir Dhillon - Some random developer guy.
