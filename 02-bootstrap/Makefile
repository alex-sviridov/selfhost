.PHONY: install install-collections install-python-modules os-upgrade k3s-upgrade k3s-kubeconfig-get

install-collections:
	ansible-galaxy collection install -r requirements.yml --force

install-python-modules:
	pip3 install netaddr

install: install-collections install-python-modules

provision:
	ansible-playbook provision.yml

os-upgrade:
	ansible-playbook os-upgrade.yml

k3s-upgrade:
	ansible-playbook k3s.orchestration.upgrade

k3s-kubeconfig-get:
	ansible-playbook provision.yml --tags get-kubeconfig