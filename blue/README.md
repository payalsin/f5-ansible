**Pre-requisites**

* Create an Access Key ID and Secret Access Key. Save the ID and key for later, use it when you run 'aws configure' This is needed so that in the playbooks you dont have to specify the AWS crendentails for each task
  - Go to IAM
  - Click on Users
  - Create a new user or use an existing user
  - Click on 'Security Credentials' tab
  - Click on generate access key  
* `pip install boto3` 
* `pip install botocore`
* If boto and botocore already installed then upgrade
  - `pip install boto3 --upgrade`
  - `pip install botocore --upgrade`
* `pip install awscli`
* Run `aws configure`, enter the following (https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html)
  - AWS Access Key ID [None]: 
  - AWS Secret Access Key [None]: 
  - Default region name [None]: us-west-2
* `pip install ansible --upgrade`

**If running a standalone playbook (no role)**
* Copy the playbook, variable files and the CFT file to the same folder on your Ansible control node
  - spin-up-blue-controller-aws.yaml
  - vars.yaml
  - blue-cft.json (The is the name I have given to the CFT) 
* Run the playbook
  - `ansible-playbook spin-up-blue-controller-aws.yaml`

**If running the playbook as a role**
* Navigate to the directory from where you run your playbooks.
* Make a new directory called roles
* Copy directory (deploy_controller_aws) to the roles directory
* Navigate back to the directory from where you run your playbooks and copy the following files
  - controller_aws.yaml
  - blue-cft.json
* Run the playbook
  - `ansible-playbook controller_aws.yaml`

>**Note - The standalone playbook and the role perform the same task. Both will spin up a blue controller and after execution the playbook will return the authentication token for user admin. The authentication token will be copied to a file with the name <your_stack_name_admin_auth_token.yaml>. This token can then be referenced in other playbooks**
