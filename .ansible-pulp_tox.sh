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

find ./molecule/*source*/group_vars/all -exec sh -c "yq w -i {} pulp_install_plugins.pulp-rpm.source_dir \/var\/lib\/pulp\/devel\/pulp_rpm" \;
find ./molecule/*upgrade*/group_vars/all -exec sh -c "yq w -i {} pulp_install_plugins.pulp-rpm.upgrade true" \;
find ./molecule/*/group_vars/all -exec sh -c "yq w -i {} pulp_install_plugins.pulp-rpm.prereq_role pulp.pulp_rpm_prerequisites" \;
find ./molecule/*/group_vars/all -exec sh -c "echo; echo {}; cat {}" \;


find ./molecule/*upgrade*/molecule.yml -exec sed -i '/quay.io\/pulp\/pulp-ci-dbuster:3.0.0/,+3 d' {} \;
find ./molecule/*upgrade*/molecule.yml -exec sed -i '/debian-10/d' {} \;
find ./molecule/*/molecule.yml -exec sed -i '/debian-10/,+3 d' {} \;

travis-wait-enhanced --timeout=60m tox
