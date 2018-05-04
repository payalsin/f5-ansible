# bigip-ansible-ha-setup
Ansible role to configure BIG-IP in a High Availability Cluster

This is a workflow to
* Configure BIG-IP1 and BIG-IP2 hostname
* Add HA VLAN on BIG-IP1 and BIG-IP2
* Add HA SELF-IP on BIG-IP1 and BIG-IP2
* Configure Sync/unicast/mirroring address on BIGIP1 and BIG-IP2
* Configure Device trust on BIG-IP1
* Add Device Group on BIG-IP1
* Add members to the device group
* Perform a config sync
   
## Requirements
* This role requires Ansible 2.5
* BIG-IP is licensed
* Packages to be installed
  - pip install f5-sdk
  - pip install bigsuds
  - pip install netaddr

## Role Variables
The variables that can be passed to this role and a brief description about them are as follows.

```
bigip1_ip: 10.192.xx.xx
bigip1_username: "admin"
bigip1_password: "admin"

bigip2_ip: 10.192.xx.xx
bigip2_username: "admin"
bigip2_password: "admin"

bigip1_hostname: bigipha1.local
bigip2_hostname: bigipha2.local

ha_vlan_information:
- name: "HA_VLAN"
  id: "3"
  interface: "2.4"

bigip1_ha_selfip: 
- name: "HA_SELF-IP"
  address: "1.1.1.4"
  netmask: "255.255.255.0"
  vlan: "{{ha_vlan_information[0]['name']}}"

bigip2_ha_selfip:
- name: "HA_SELF-IP"
  address: "1.1.1.5"
  netmask: "255.255.255.0"
  vlan: "{{ha_vlan_information[0]['name']}}"

vlan_information:
- name: "External_VLAN"
  id: "1195"
  interface: "2.2"
- name: "Internal_VLAN"
  id: "1695"
  interface: "2.2"

bigip1_selfip_information:
- name: 'External-SelfIP'
  address: '10.168.56.10'
  netmask: '255.255.255.0'
  vlan: "{{vlan_information[0]['name']}}"
- name: 'Internal-SelfIP'
  address: '192.168.56.10'
  netmask: '255.255.255.0'
  vlan: "{{vlan_information[1]['name']}}"

floating_selfip_information:
- name: 'External-Floating-SelfIP'
  address: '10.168.56.15'
  netmask: '255.255.255.0'
  vlan: "{{vlan_information[0]['name']}}"
- name: 'Internal-Floating-SelfIP'
  address: '192.168.56.15'
  netmask: '255.255.255.0'
  vlan: "{{vlan_information[1]['name']}}"

bigip2_selfip_information:
- name: 'External-SelfIP'
  address: '10.168.56.11'
  netmask: '255.255.255.0'
  vlan: "{{vlan_information[0]['name']}}"
- name: 'Internal-SelfIP'
  address: '192.168.56.11'
  netmask: '255.255.255.0'
  vlan: "{{vlan_information[1]['name']}}"
```

## Example Playbook
```
- hosts: bigip
  gather_facts: false
  roles:
  - { role: payalsin.bigip-ansible-virtualserver }

```

## Credential storage

Because this role includes usage of credentials to access your BIG-IP, I recommend that you supply these variables in an ansible-vault encrypted file.

This can be supplied out-of-band of this role

Steps:
- Store your vault password in a file - '~/.vault_pass.txt'
- Execute playbook as follows - ansible-vault encrypt <<variable_filename>> --vault-password-file ~/.vault_pass.txt

For more information refer to: http://docs.ansible.com/ansible/latest/playbooks_vault.html

## Certificate validation
To validate the SSL certificates of the BIG-IP REST API
- set validate_certs: true
- Generate a public private key pair
- Store the public key on BIG-IP (https://support.f5.com/csp/article/K13454#bigipsshdaccept)

## Credits
https://github.com/F5Networks/f5-ansible
