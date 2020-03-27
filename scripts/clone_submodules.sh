#!/usr/bin/env bash

if [ -z "${OPENSTACK_RELEASE}" ]; then
    echo "OPENSTACK_RELEASE is not defined. Abort."
    exit 1
fi

mkdir submodules -p
touch .gitmodules

if [ -d "submodules/kolla" ]; then 
    cd submodules/kolla 
    gitCurrentBranch=$(git rev-parse --abbrev-ref HEAD)
    if [ "$gitCurrentBranch" != "${OPENSTACK_RELEASE}" ]; then
        git checkout stable/${OPENSTACK_RELEASE}
    fi
else
    echo git submodule add -b stable/${OPENSTACK_RELEASE} https://github.com/openstack/kolla submodules/kolla
    git submodule add -b stable/${OPENSTACK_RELEASE} https://github.com/openstack/kolla submodules/kolla 
fi

if [ -d "submodules/kolla-ansible" ]; then 
    cd submodules/kolla-ansible
    if [ "$gitCurrentBranch" != "${OPENSTACK_RELEASE}" ]; then
        git checkout stable/${OPENSTACK_RELEASE}
    fi
else
    echo git submodule add -b stable/${OPENSTACK_RELEASE} https://github.com/openstack/kolla-ansible submodules/kolla-ansible
    git submodule add -b stable/${OPENSTACK_RELEASE} https://github.com/openstack/kolla-ansible submodules/kolla-ansible
fi
