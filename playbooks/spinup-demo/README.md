Demo
----

Pre-requisites:
- BIG-IP VE template is created on vcenter
- GOVC is installed on ansible tower host
  - https://github.com/vmware/govmomi/releases
- License key is known and provided while running the playbook
- BIG-IP DNS (GTM) is preconfigured to the following extent
  - Listerner 
  - Datacenter
  - LTM1 in sync
  - Pool - having LTM1 virtual IP's as part of the pool members
  - WideIP - Pool assigned to WideIP
- DNS server is set to BIG-IP DNS Listerner IP
- DHCP is enabled in vCenter
- ASM policy is available for export to the BIG-IP (asm_policy.xml)

Scenario1: Spin up BIG-IP VE in Vmware
----------------------------------
Playbook: spinup_vmware.yaml
Variables entered as part of survey using Ansible Tower
- Guest name in vcenter (vm_guest_name)
- BIG-IP template (template_src)
- License Key (license_key)
- Virtual Server Name (vip_name)
- Virtual Server IP Address (vip_ip)
- Virtual Server Port (vip_port)

Playbook tasks:
- Deploy BIG-IP in vCenter using
- Reconfigure the network adaptor settings to be assigned to the correct port group
- Grab the VM IP assigned by DHCP to the BIG-IP VE
- License the BIG-IP VE
- Provision the BIG-IP with ASM module
- Onboard the BIG-IP (Hostname/NTP/DNS/SSHD)
- Network the BIG-IP (VLAN/Self-IP)
- Import and activate the ASM policy
- Add pool and pool members
- Add virtual server and attach the ASM profile to it

Scenario2: Sync the new BIG-IP LTM to the existing BIG-IP DNS
-------------------------------------------------------------
ONE MANUAL STEP: After scenario1 is run and new BIG-IP is spun up, it needs to exchange SSL certs with the BIG-IP DNS in order for them to be able to communicate.
- Login to the BIG-IP DNS and run the following two commmands:
   - /usr/local/bin/bigip_add <ltm_selfip>
   - /usr/local/bin/big3d_install <ltm_selfip>
- For more details : https://support.f5.com/csp/article/K14495

Playbook: global_lb.yaml
Variables entered as part of survey using Ansible Tower
- BIG-IP address (ltm1_IPAddress) (BIG-IP already synced with BIG-IP DNS)
- Virtual server name in ltm1 which needs to be disabled (ltm1_vip)
- Virtual server name in newly created ltm which needs to be added to the DNS pool (ltm1_vip)

Playbook tasks:
- Create the new LTM server (ltm2) and assign to existing DNS datacenter
- BIG-IP DNS now has visibility into all virtual servers on the ltm2, add the ltm2 virtual server to the existing dns pool
- Disable the virtual server on ltm1
