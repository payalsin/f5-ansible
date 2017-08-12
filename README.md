# f5-ansible
Ansible playbooks using BIG-IP ansible modules

Workflows
---------
- HA: Playbook to create a BIG-IP HA pair using the bigip_command module - "create-ha-plyabook.yaml"
- iApp: Playbook to upload the iApp to the BIG-IP and then deploy the iApp -"upload_and_deploy_iapp.yml"

Private Cloud
-------------
- Playbook to spin up BIG-IP in private cloud (vCenter) using govc (vShpere CLI) - "spin_up_BIGIP_vCenter_govc.yaml"
- Playbook to spin up BIG-IP in provate cloud (vCenter) using vsphere_guest ansible module - "spin_up_BIGIP_vCenter_guest_module.yaml"

Public Cloud
------------
- Playbook to spin up BIG-IP CFT in AWS - "spin_up_BIGIP_CFT_AWS.yaml"
