## Manage and upgrade vCMP hardware using Ansible

I am going to start with a definition of vCMP since many use it but don’t know what it stands for: **Virtual Clustered Multiprocessing™ (vCMP®)** is a feature of the BIG-IP® system that allows you to provision and manage multiple, hosted instances of the BIG-IP software on a single hardware platform.

With managing multiple instances on a single platform there is almost certainly repetitiveness of tasks that are performed. The vCMP platform is no exception. The vCMP host can consist of multiple slots and multiple guests can be distributed among those slots. There are different ways to provision vCMP guests on a host depending on the hardware specifications of the host. I wont go into details here but [click here for great resource to guide you on vCMP guest distribution on vCMP hosts](https://support.f5.com/csp/article/K14727).

While there is a inclination to use a software only solution, F5 BIG-IP vCMP can be a great solution since it provides the performance and relaibility you can get from hardware along with an added layer of virtulization. [Learn more about the benefits and comparisions of vCMP over other solutions](https://www.f5.com/services/resources/white-papers/virtual-clustered-multiprocessing-vcmp)

In this article I am going to talk about how you can use Ansible to deploy vCMP guests and also talk about how you can upgrade software on those guests.

**Part1: Deploy vCMP guests**

The BIG-IP image is downloaded and accessible in a directory (/root/images) local from where the ansible playbook is being run 

**Example playbooks: vcmp_host_mgmt.yml**

Deploy 1 vCMP guest

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

Compelete list of parameters that used for the module above: https://docs.ansible.com/ansible/latest/modules/bigip_vcmp_guest_module.html

**Few pointers:**
- The vCMP guest when created can be set to any initial BIG-IP image that is present on the vCMP host (that could be the image and version of the vCMP host itself)
- If VLAN's need to be assigned to the vCMP guest at the time of creation those VLAN's need to be added to the host beforehand
- Different cores and slots can be assigned to the vCMP guest
- Managment network can be set to bridged or isolated 

Now the code above deploys 1 vCMP guest. If you have multiple vCMP guests that need to be deployed there are a number of ways to do that:
- Variable file: A variable file can be used to store information on each vCMP guest and then referenced within the playbook
- Loops: Using a loop within the task itself 

Let's take a look at each option

Variable file: Deploy mulitple vCMP guests using the async operation and a variable file

**Example variable file: variable_file.yml**

```
vcmp_guests:
- name: "vCMP85"
  ip: "10.192.73.85"
- name: "vCMP86"
  ip: "10.192.73.86"
```

**Example playbook variable file: vcmp_host_mgmt_var.yml**

```
- name: vCMP MGMT
  hosts: localhost
  connection: local

  vars:
   image: "BIGIP-14.1.2-0.0.37.iso"

  vars_files:
  - variable_file.yml

  tasks:
  - name: Setup provider
    set_fact:
     vcmp_host_creds:
      server: "10.192.xx.xx"
      user: "admin"
      password: "admin"
      server_port: "443"
      validate_certs: "no"

  - name: Upload software on vCMP Host
    bigip_software_image:
      image: "/root/images/{{image}}"
      provider: "{{vcmp_host_creds}}"

  - name: Create vCMP guest
    bigip_vcmp_guest:
      name: "{{item.name}}"
      initial_image: "{{image}}"
      mgmt_network: bridged
      mgmt_address: "{{item.ip}}/24"
      mgmt_route: 10.192.73.1
      cores_per_slot: 1
      state: present
      provider: "{{vcmp_host_creds}}"
    with_items: "{{vcmp_guests}}"
    register: _create_vcmp_instances
    # This will run the tasks in parallel and spin the vCMP guests simultaneously
    async: 900
    poll: 0

  - name: Wait for creation to finish
    async_status:
      jid: "{{ item.ansible_job_id }}"
    register: _jobs
    until: _jobs.finished
    delay: 10  # Check every 10 seconds. Adjust as you like.
    retries: 85  # Retry up to 10 times. Adjust as needed.
    with_items: "{{ _create_vcmp_instances.results }}"
```
Click here to learn more about the [async](https://blog.crisp.se/2018/01/27/maxwenzin/how-to-run-ansible-tasks-in-parallel) and [async_status module](https://docs.ansible.com/ansible/latest/user_guide/playbooks_async.html)

Next let's look at an example of using loops

**Example playbook loops: vcmp_host_mgmt_loops.yml**

Deploy mulitple vCMP guests using the async operation

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
    - { name: 'vCMP86', ip: '10.192.73.86' }
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

**Part2: Software upgrade**

Now once we have the vCMP guests deployed let's consider a scenario where a new software BIG-IP build is out with a fix for the vCMP guest.

[Go through certain considerations](https://support.f5.com/csp/article/K13748) while upgrading vCMP guests.

**Example playbook: vcmp_guest_mgmt.yml**

```
- name: vCMP guest MGMT
  hosts: localhost
  connection: local

  vars:
   image: "BIGIP-14.1.2.2-0.0.4.iso"

  tasks:
  - name: Setup provider
    set_fact:
     vcmp_guest_creds:
      server: "10.192.xx.xx"
      user: "admin"
      password: "admin"
      server_port: "443"
      validate_certs: "no"

  - name: Upload software on vCMP guest
    bigip_software_image:
      image: "/root/images/{{image}}"
      provider: "{{vcmp_guest_creds}}"

  # This command will list of the volumes available and the software present on each volume
  - name: run show version on remote devices
    bigip_command:
     commands: show sys software
     provider: "{{vcmp_guest_creds}}"
    register: result

  - debug: msg="{{result.stdout_lines}}"

  # Enter the volume from above to which you want to install the software
  - pause:
      prompt: "Choose the volume for software installation (Example format HD1.2)"
    register: volume

  # If the format of the volume entered does not match below the playbook will fail
  - fail:
      msg: "{{volume.user_input}} is not a valid volume format"
    when: volume.user_input is not regex("HD[1-9].[1-9]")

  # This task will install the software and then boot the BIG-IP to that specific volume
  - name: Ensure image is activated and booted to specified volume
    bigip_software_install:
     image: "{{image}}"
     state: activated
     volume: "{{volume.user_input}}"
     provider: "{{vcmp_guest_creds}}"

```

The upgrade procedure for vCMP guests is not just applicable for vCMP, this process can be used for a virtual edition or any hardware appliance of BIG-IP. Infact the same process is used on vCMP hosts as well.

Although for vCMP hosts there are [other factors to consider](https://support.f5.com/csp/article/K15930#p17) before performing an upgrade.

Code above tested with Ansible 2.9 and [a subset of modules used in the playbooks from the list of complete F5 ansible modules available](https://docs.ansible.com/ansible/latest/modules/list_of_network_modules.html#f5)

Happy automating !!
