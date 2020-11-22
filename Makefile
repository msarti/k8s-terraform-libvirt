set-up:
	cd terraform && $(MAKE) apply
	- cd ansible && until ansible-playbook playbooks/ping.yaml > /dev/null; do echo "wait 2 min for resources availability..." && sleep 120; done
	cd ansible && ansible-playbook playbooks/first_setup.yaml


tear-down:
	cd terraform && $(MAKE) destroy

