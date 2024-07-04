# Creating AWS resources using Terraform

# Prerequisites
AWS CLI should be installed in your system. 'aws configure' should be set up with `default` profile set with the access key and secret access key. 

# Installing Terraform
Terraform can be downloaded from [here](https://www.terraform.io/downloads.html)

Mac users:
Once you have installed Terraform by unzipping and double clicking the terraform executable, you have to add the location to the system path. You can do this by:

```echo $"export PATH=\$PATH:$PATH:$(pwd)" >> ~/.bash_profile```

Then, load the env variable into the terminal by

```source ~/.bash_profile```

To check if Terraform is installed correctly:

```terraform --version```

If its installed correctly, you will see a version number.

# About the project
The infra consists of :
* VPC (CIDR range: 10.0.0.0/16)
* Internet Gateway
* 3 Public Subnets (10.0.0.0/24, 10.0.1.0/24, 10.0.2.0/24) - attached to public route table
* 3 Private Subnets (10.0.3.0/24, 10.0.4.0/24, 10.0.5.0/24)
* Public EC2 instance
* Security group - currently for EC2 - allowing HTTP(S) ingress

### Terraform plan
terraform plan -var-file=./env_vars/dev.tfvars

### Terraform apply
terraform apply -var-file=./env_vars/dev.tfvars