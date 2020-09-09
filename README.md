# prometheus-terraform

This project is comprised of a terraform script which when run will create the necessary infrastructure for a prometheus instance  

## Prerequisites

* [Terraform](https://www.terraform.io/); tested with version v0.12.09,
* [AWS Command Line Interface](https://aws.amazon.com/cli/) 1.16.155+

### AWS Credentials

AWS credentials are selected based on the value of the `AWS_PROFILE` environmental variable and AWS CLI profile configuration. It is not possible to run the Terraform scripts without this variable set. Either export this in your current shell environment or permanently add it to your `~/.bash_profile` or equivalent.

## Terraform

These scripts make use of Infrastructure as Code (IaC) and depend on Terraform as the primary tool for managing and applying infrastructural changes. Documentation can be found for this tool on the [Terraform Guides](https://www.terraform.io/guides/index.html) webpage.

## Project hierarchy

The following filesystem structure is used in this project:
```
prometheus-terraform
  ├── terraform/               - General terraform config
  └── module-ec2-instances/    - Config specific to ec2 instances
  └── module-route53-records/  - Config for creating and editing route53 records
  └── module-security-groups/  - Config for creating and editing security groups
```
## Configuration
### Terraform Variables

The following variables are required:

Variable    | Description | Examples
-------------|------------ |---------------
aws_region  | AWS region to create the infrastructure  | eu-west-2
environment  | AWS environment in which to create the infrastructure  | development
web_fqdn | Prometheus targets | web.
metrics_port | The desired port | 9999
instance_count | How many instances you want | 1
tag_environment | Which environment you want to tag | my-environment
ssh_keyname | The keyname of the ssh profile you want to use | my-environment
private_key_path | The path of your private ssh key | "~/.mysshkey"
zone_id | The DNS zone id you want to use | 12345
zone_name | The DNS zone name you want to use | myzone.abc.com

## State

Terraform state is stored remotely in an S3 bucket. The region, state bucket name, and workspace prefix are determined dynamically based on the configuration of the host environment and the `AWS_PROFILE` environment variable.

## Environment-specific configuration

Environment-specific configuration tasks are performed after instance launch using [cloud-init](https://cloud-init.io/) directives from [user data](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html). Terraform templates have been setup for individual files that require provisioning after instance launch and suitable variable interpolations have been added where required.

The following structure has been implemented for `cloud-init` configuration for each applicable Terraform module:

```
groups
  ├── prometheus
  │    ├── module-ec2-instances    - directory for EC2 configuration, including cloud-init
  │    │    └── cloud-init         
  │    │        ├── files          - directory for YAML files that contain no variable interpolations
  │    │        ├── templates      - directory for templates that include variable interpolations
  │    │        └── cloud-init.tf  - main cloud-init configuration definition for this module
  └── ...


## Applying infrastructure changes

The Prometheus-terraform scripts can be run using the Terraform-runner.

View usage instructions for the terraform-runner on the internal Confluence site
