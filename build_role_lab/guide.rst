Build a Role Lab
================

.. contents:: :depth: 3

What is an Ansible Role
-----------------------

Ansible role is an independent component which allows reuse of common configuration steps. Ansible role has to be used within playbook. Ansible role is a set of tasks to configure a device to serve a certain purpose like configuring a service. Roles are defined using YAML files with a predefined directory structure

We will go over the directory structure later in the lab

For complete documentation refer to https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html

Why use an Ansible Role
-----------------------

Advantages: The proper organization of roles will not only simplify your work with scripts, improving their structure and further support, but also eliminates duplication of tasks in playbooks. A role is a way of splitting Ansible tasks into files which are easier to manipulate with.

What is Ansible Galaxy
----------------------

Ansible Galaxy refers to the Galaxy website where users can share roles, and to a command line tool for installing, creating and managing roles. It it open to the community, anyone can publish and consume roles form galaxy.

Example of roles in galaxy
~~~~~~~~~~~~~~~~~~~~~~~~~~

- Installing NGINX regardless of destination platform. (https://galaxy.ansible.com/nginxinc/nginx)
  - Role can figure out if its debian or ubuntu or others and run the appropriate modules/commands to install nginx

- Group common tasks together to get a desired outcome
  - Role to deploy a global load balancing solution (GSLB)
  - Role to toublshoot the BIG-IP (create tech support, backup and restore confguration etc.)
  
Complete list of  `F5 Ansible roles <https://galaxy.ansible.com/f5devcentral>`_ in galaxy

Get started on creating roles
-----------------------------

There is an ansible-galaxy init command that can be used to create the base directory structure for writing a role. All the directories dont have to be utilized.

.. code:: rst
  
  ansible-galaxy init role_name

The above will create the following directory structure in the current working directory:

.. code:: rst

   role_name/
     README.md
     .travis.yml
     defaults/
        main.yml
     files/
     handlers/
        main.yml
     meta/
        main.yml
     templates/
     tests/
        inventory
        test.yml
     vars/
        main.yml

- Each directory will have a 'main.yml'.
- The tasks directory also has a main.yml file which gets executed/called automatically when a role is referenced
- handlers - contains handlers, which may be used by this role or even anywhere outside this role.
- defaults - default variables for the role (see Using Variables for more information).
- vars - other variables for the role (see Using Variables for more information).
- files - contains files which can be deployed via this role.
- templates - contains templates which can be deployed via this role. (inlcuding jinja2)
- tests - good for automated testing of role, but will not be covered today
- README (markdown) is important for adding descriptions and context to your role for others to use

F5 Ansible roles
----------------

Once you have the directory sturcture defined above,lets take a look at how to add content into each of the directories

Role1 - Using Ansible modules
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
[Forrest]

Now that the role is ready let's take a look at how we can reference a role within a playbook for execution

Referencing a Role in a playbook
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
There is more that one way to reference a role within a playbooks. 

Classic (original way) - ansible will check each roles directory for tasks/handlers/vars/default vars and other objects to add for the current host within the playbook.

.. code:: rst

   ---
   - hosts: webservers
     roles:
      - common
      - webservers

Use Roles inline (2.4+)

.. code:: rst

   ---
   - hosts: webservers
     tasks:
     - import_role:
       name: example
     - include_role:
       name: example
       
- Import (static) vs Include (dynamic)
  - Import tasks are treated more like part of the actual playbook.
  - Include tasks are added when the playbook gets to those tasks.
  - Include can loop since it’s a tasks
  - Cannot reference/view objects within include tasks such as (--list-tasks , --start-at-task, etc)

Roles can use vars, tags, and conditionals just like other tasks

.. code:: rst

   - hosts: webservers
     tasks:
     - include_role:
        name: foo_app_instance
       vars:
        dir: '/opt/a'
        app_port: 5000

Creating and executing playbook using role
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
[Forrest]

Role2 - Using AS3 
~~~~~~~~~~~~~~~~~
[Forrest]

Build your own F5 Ansible Role
------------------------------

Above are examples of how to develop a role and what a role wrt F5 BIG-IP would look like. Below are a few more use-cases for which a role can be developed. 

You are encouraged to pick one of the use cases below and.or come up with your own F5 BIG-IP use case and build a role for it. If completed we will upload the role to Ansible Galaxy for the community to be able to consume.

- Upload and attach iRules
- Display relevant information about BIG-IP (software version/hardware etc.)
- Parse virtual server information and display the default pool hence and pool members that belong to the pool

Take a look at `F5 Ansible modules available <https://docs.ansible.com/ansible/latest/modules/list_of_network_modules.html#f5>`_  and get started 
