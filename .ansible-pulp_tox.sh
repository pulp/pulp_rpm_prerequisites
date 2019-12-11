#!/bin/bash
# wrapper for inserting pulp_rpm_prerequisites into the ansible-pulp CI
cd ..
if [ ! -e ansible-pulp ]; then
  git clone https://github.com/pulp/ansible-pulp
fi
cd ansible-pulp
if [ ! -e roles/pulp.pulp_rpm_prerequisites ]; then
  ln -s $TRAVIS_BUILD_DIR roles/pulp.pulp_rpm_prerequisites
fi

find */group_vars/all -exec sh -c "yq w -i {} pulp_use_system_wide_pkgs true" \;
find */group_vars/all -exec sh -c "yq w -i {} pulp_install_plugins.pulp-rpm.app_label rpm" \;
find */group_vars/all -exec sh -c "yq w -i {} pulp_install_plugins.pulp-rpm.source_dir git+https:\/\/github.com\/pulp\/pulp_rpm.git#egg=pulp-rpm" \;
find */group_vars/all -exec sh -c "yq w -i {} pulp_install_plugins.pulp-rpm.prereq_role pulp.pulp_rpm_prerequisites" \;

find ./molecule/*/molecule.yml -exec sed -i 's/debian-10/fedora-30/g' {} \;
find ./molecule/*/molecule.yml -exec sed -i 's/debian:buster/fedora:30/g' {} \;

travis-wait-enhanced --timeout=60m tox
