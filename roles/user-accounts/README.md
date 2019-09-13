Setup-Docker
=========

This role sets-up TerrexTech user-accounts and roles (for TerrexTech members).

Requirements
------------

The remote system should have Kubernetes masters/workers setup.

Role Variables
--------------

**ansible_templates_dir**: Directory where templates for the role exist.

**user_certs_dir**: Directory where user-certificates should be generated.
**user_roles_dir**: Directory where manifests for user-roles and role-bindings should be generated.

```YAML
  - full_ns: development
    short_ns: dev
  - full_ns: staging
    short_ns: stag
  - full_ns: production
    short_ns: prod
```

Dependencies
------------

* roles/bootstrap
* roles/kube-master
* roles/kube-worker
* roles/cni

Example Playbook
----------------

```yaml
- name: Setup cluster user-accounts
  hosts: test-host
  gather_facts: true
  become: true
  roles:
    - role: user-accounts
      tags:
        - accounts
        - auth
```

License
-------

WTFPL

Author Information
------------------

Jaskaranbir Dhillon - Some random developer guy.
