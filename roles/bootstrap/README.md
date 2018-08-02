Setup-Docker
=========

This role installs Docker and Docker-Compose.

Requirements
------------

The remote system should have Python3 installed (or change the `host_vars` accordingly).

Role Variables
--------------

**docker_version**: Docker version to install.
**docker_users**: Users to add to `docker` group, so they have sudo-less access to Docker.
**docker_compose_version**: Version of Docker-Compose to install.
**docker_compose_install_location**: Location where docker-compose binary is downloaded.
**kubernetes_packages**: Packages to install for setting up Kubernetes.

Dependencies
------------

None

Example Playbook
----------------

```yaml
- name: Install base packages
  hosts: test-hosts
  gather_facts: true
  become: true
  roles:
    - role: bootstrap
      tags: bootstrap
```

License
-------

WTFPL

Author Information
------------------

Jaskaranbir Dhillon - Some random developer guy.
