Setup-Docker
=========

This role installs the addons to Kubernetes cluster. Addons installed:

* Helm/Tillar
* Nginx Ingress (Internal Services)
* Nginx Ingress (External Services)
* Prometheus
* Grafana (includes a dashboard, using Prometheus as DataSource)

Requirements
------------

The remote system should have Kubernetes masters/workers setup.

Role Variables
--------------

**ansible_templates_dir**: Directory where templates for the role exist.

**helm_service_account**: Service-account name for Helm/Tiller.
**kube_rbac_dir**: Directory where Kubernetes service-account manifests should be copied after templating.
**helm_certs_dir**: Directory where Helm certificates should be generated.
**helm_values_dir**: Directory containing templates for Helm-charts' config files.

**admin_namespace_full**: Full-name for the main namespace.
**admin_namespace_short**: Short-name for the main namespace.

**helm_namespaces**: An array with namespaces where helm should be installed. Should have short-name and full-name for namespace. For example:

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
- name: Setup Kubernetes addons
  hosts: test-host
  gather_facts: true
  become: true
  roles:
    - role: addons
      tags: addons
```

License
-------

WTFPL

Author Information
------------------

Jaskaranbir Dhillon - Some random developer guy.
