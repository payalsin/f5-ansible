## Manage and upgrade vCMP hardware using Ansible

I am going to start with a definition of vCMP since many use it but don’t know what it stands for: **Virtual Clustered Multiprocessing™ (vCMP®)** is a feature of the BIG-IP® system that allows you to provision and manage multiple, hosted instances of the BIG-IP software on a single hardware platform.

With managing multiple instances on a single platform there is almost certainly repetitiveness of tasks that are performed. The vCMP platform is no exception. The vCMP host can consist of multiple slots and multiple guests can be distributed among those slots. There are different ways to provision vCMP guests on a host depending on the hardware specifications of the host. I wont go into details here but click here for great article to guide you on vCMP guest distribution on vCMP hosts.

In this article I am going to talk about how you can use Ansible to deploy vCMP guests and also talk about how you can upgrade software on those guests.

**Part1: Deploy vCMP guests**
- The BIG-IP image is downloaded and accessible in a directory (/root/images) local from where the ansible playbook is being run 

**vcmp_host_mgmt.yml**
- Deploy 1 vCMP guest

```
- name: vCMP MGMT
  hosts: localhost
  connection: local

  vars:
   image: "BIGIP-14.1.2-0.0.37.iso"

  tasks:
  # Setup the cerdentials used to login to the BIG-IP and store it
  # in a fact that can be used in subsequent tasks
  - name: Setup provider
    set_fact:
     vcmp_host_creds:
      server: "10.192.xx.xx"
      user: "admin"
      password: "admin"
      server_port: "443"
      validate_certs: "no"

  # Upload the software image to the BIG-IP (vCMP host)
  - name: Upload software on vCMP Host
    bigip_software_image:
      image: "/root/images/{{image}}"
      provider: "{{vcmp_host_creds}}"

  # Deploy a vCMP guest with the base version of the software image uploaded above
  - name: Create vCMP guest
    bigip_vcmp_guest:
      name: "vCMP85"
      initial_image: "{{image}}"
      mgmt_network: bridged
      mgmt_address: 10.192.73.85/24
      mgmt_route: 10.192.73.1
      state: present
      provider: "{{vcmp_host_creds}}"
```

The code above deploys 1 vCMP guest. If you have multiple vCMP guests that need to be deployed there are a number of ways to do that:
- A variable file can be used to store information on each vCMP guest and then referenced within the playbook
- Using a loop within the task itself - Let's take a look at this option

**vcmp_host_mgmt.yml**
- Deploy mulitple vCMP guests using a variable file

```
- name: vCMP MGMT
  hosts: localhost
  connection: local

  vars:
   image: "BIGIP-14.1.2-0.0.37.iso"
   
  tasks:
  # Setup the cerdentials used to login to the BIG-IP and store it
  # in a fact that can be used in subsequent tasks
  - name: Setup provider
    set_fact:
     vcmp_host_creds:
      server: "10.192.xx.xx"
      user: "admin"
      password: "admin"
      server_port: "443"
      validate_certs: "no"

  # Upload the software image to the BIG-IP (vCMP host)
  - name: Upload software on vCMP Host
    bigip_software_image:
      image: "/root/images/{{image}}"
      provider: "{{vcmp_host_creds}}"

  # Deploy a vCMP guest with the base version of the software image uploaded above
  - name: Create vCMP guest
    bigip_vcmp_guest:
      name: "{{item.name}}"
      initial_image: "{{image}}"
      mgmt_network: bridged
      mgmt_address: "{{item.ip}}/24"
      mgmt_route: 10.192.73.1
      state: present
      provider: "{{vcmp_host_creds}}"
    with_items: 
    - { name: 'vCMP85', ip: '10.192.73.85' }
    - { name: 'vcMP86', ip: '10.192.73.86' }
    register: _create_vcmp_instances
    # This will run the tasks in parallel and spin the vCMP guests simultaneously
    async: 900
    poll: 0

  - name: Wait for tasks creation above to finish
    async_status:
      jid: "{{ item.ansible_job_id }}"
    register: _jobs
    until: _jobs.finished
    delay: 10  # Check every 10 seconds. Adjust as you like.
    retries: 85  # Retry up to 10 times. Adjust as needed.
    with_items: "{{ _create_vcmp_instances.results }}"

 ```

Now once we have the vCMP guests deployed let's consider a scenrio where now a new build is out with a new fix on the vCMP host.

**Part2: Softwate upgrade**

Example playbook:
```
```

Next let's also look at the option of upgrading the vCMP guests:

Example playbook:
```
```

The upgrade procedure for vCMP guests is not just applicable for vCMP, this process can be used for a virtual edition or any hardware appliance of BIG-IP as well.

List of modules used in the playbooks can be found at:

Happy auotmating !!
