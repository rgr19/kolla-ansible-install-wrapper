# special targets not associated with files, e.g.: 
# clean:
#  rm -rf *.o
.PHONY: setup setup setupv check all

export OPENSTACK_RELEASE = train
export SUPERUSER = kolla
export WHICH_PYTHON = $(shell which python)
export PROJECT_NAME = $(shell basename $(PWD))
export ANSIBLE_VAULT_PASSWORD_FILE = ${HOME}/.ansible/vaults/${PROJECT_NAME}
export BROADCAST = $(shell python3 scripts/find_broadcast.py)

SETUP=ANSIBLE_NOCOWS=1 ansible-playbook setup.yml -i inventories -e superuser=${SUPERUSER}
WOL=ANSIBLE_NOCOWS=1 ansible-playbook wol.yml -i inventories/master
KOLLA_INIT_RUNONCE=bash files/kolla_ansible_init_runonce.sh
KOLLA_RUN_DEMO_IMAGE=bash files/kolla_ansible_run_demo_image.sh
KOLLA_DEPLOYER=bash files/kolla_ansible_deployer.sh
KOLLA_DESTROYER=bash files/kolla_ansible_destroyer.sh

check-env:
ifndef BROADCAST
	$(error BROADCAST is undefined)
endif
ifndef SUPERUSER
	$(error SUPERUSER is undefined)
endif
ifndef PROJECT_NAME
	$(error PROJECT_NAME is undefined)
endif
ifndef OPENSTACK_RELEASE
	$(error OPENSTACK_RELEASE is undefined)
endif
ifndef WHICH_PYTHON
	$(error WHICH_PYTHON is undefined)
endif

prepare: check-env
	pip install -r requirements.txt
	#bash scripts/install_ansible.sh
	bash scripts/setup_vault.sh
	bash scripts/encrypt_credentials.sh
	#bash scripts/clone_submodules.sh

wait: check-env
	python3 scripts/wait_for_slaves.py

wol: check-env
	@echo "[PLAY] wake on lan"
	$(WOL)

setup: check-env prepare wait
	@echo "[PLAY] setup"
	$(SETUP) --skip-tags debug
setupd: check-env prepare wait
	@echo "[PLAY] setup"
	$(SETUP)
setupv: check-env  prepare wait
	@echo "[PLAY] setupv"
	$(SETUP) -vvvvv

check: check-env wait prepare
	@echo "[PLAY] check"
	$(SETUP) --syntax-check

deploy: check-env wait prepare setup
	@echo "[RUN] kolla-ansible deployer"
	$(KOLLA_DEPLOYER)

init-runonce: check-env wait prepare setup
	@echo "[RUN] kolla-ansible init-runonce"
	$(KOLLA_INIT_RUNONCE)

run-demo-image: check-env wait prepare setup
	@echo "[RUN] kolla-ansible run demo image"
	$(KOLLA_RUN_DEMO_IMAGE)

destroy: check-env wait prepare setup
	@echo "[RUN] kolla-ansible destroyer"
	$(KOLLA_DESTROYER)

all: check-env setup wol check setup
