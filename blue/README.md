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
  AWS Access Key ID [None]: 
  AWS Secret Access Key [None]: 
  Default region name [None]: us-west-2 (Right now this is the one supported for Blue)
* `pip install ansible --upgrade`
* Run the playbook
  - Copy the playbooks, variable files and the CFT file to the same folder when running via CLI
  - `ansible-playbook playbook-name`