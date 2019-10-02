Pulp 3 RPM plugin prerequisites
===============================

This role installs prerequisites for pulp-rpm plugin use.

Requirements
------------

Each currently supported operating system has a matching file in the "vars"
directory.

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    ---
    - hosts: all
      vars:
        pulp_default_admin_password: password
        pulp_settings:
          secret_key: secret
        pulp_install_plugins:
          pulp-rpm:
            prereq_role: "pulp-rpm-prerequisites"
      roles:
        - pulp-database
        - pulp-workers
        - pulp-resource-manager
        - pulp-webserver
        - pulp-content
      environment:
        DJANGO_SETTINGS_MODULE: pulpcore.app.settings

License
-------

GPLv3

Author Information
------------------

Pulp Team
