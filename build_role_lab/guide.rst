Build a Role Lab
================

What is an Ansible Role
-----------------------

Ansible role is an independent component which allows reuse of common configuration steps. Ansible role has to be used within playbook. Ansible role is a set of tasks to configure a device to serve a certain purpose like configuring a service. Roles are defined using YAML files with a predefined directory structure

Roles expect files to be in certain directory names. Roles must include at least one of these directories, however it is perfectly fine to exclude any which are not being used. When in use, each directory must contain a main.yml file, which contains the relevant content:

tasks - contains the main list of tasks to be executed by the role.
handlers - contains handlers, which may be used by this role or even anywhere outside this role.
defaults - default variables for the role (see Using Variables for more information).
vars - other variables for the role (see Using Variables for more information).
files - contains files which can be deployed via this role.
templates - contains templates which can be deployed via this role.
meta - defines some meta data for this role. See below for more details.

For complete documentation refer to https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html

Why use an Ansible Role
-----------------------

Advantages: The proper organization of roles will not only simplify your work with scripts, improving their structure and further support, but also eliminates duplication of tasks in playbooks. A role is a way of splitting Ansible tasks into files which are easier to manipulate with.

What is Ansible Galaxy
----------------------

Ansible Galaxy refers to the Galaxy website where users can share roles, and to a command line tool for installing, creating and managing roles. It it open to the community, anyone can publish and consume roles form galaxy.

Samples of some `F5 Ansible roles <https://galaxy.ansible.com/search?deprecated=false&keywords=bigip&order_by=-relevance&page=1>`_ in galaxy

F5 Ansible roles
----------------

Role1 - Using Ansible modules
[Forrest]

Role2 - Using AS3 
[Forrest]

Build your own F5 Ansible Role
------------------------------

Above are examples of how to develop a role and what a role wrt F5 BIG-IP would look like. Below are a few more use-cases for which a role can be developed. 

You are encouraged to pick one of the use cases below and.or come up with your own F5 BIG-IP use case and build a role for it. If completed we will upload the role to Ansible Galaxy for the community to be able to consume.

- Upload and attach iRules
- Display relevant information about BIG-IP (software version/hardware etc.)
- Parse virtual server information and display the default pool hence and pool members that belong to the pool
