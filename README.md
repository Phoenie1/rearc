### Repo for Rearc "Quest in the Clouds"

## Introduction
This repo contains Matthew White's solution to the Rearc "Quest in the Clouds" challenge.  It consists of Terraform and bash shell code and the code needed to containerize a node.js web application provided by Rearc.

## Getting Started

Prerequisites:
1. That you have the AWS CLI, Terraform and Docker already installed on the computer you are using to install this repo.
1. That you have access to an AWS account with a login with the ability to create and destroy Load Balancers and ECS services, and an access key/secret key pair, and with that the AWS CLI working in that account. This could be an account with full administrative privileges, however I prefer that such an account, used by DevOps and other functions, does not have the ability to create IAM entitiesr, security groups, or NACLs.
1. That the AWS account has a pre-existing VPC with at least two publicly accessible subnets.
1. The AWS account has, pre-made, two security groups for this challenge:
 - One for the Application Load Balancer which allows inbound port 443 from all IP addresses
 - One for ECS which allows inbound port 3000 from the ALB security group specified above.
 - I do it this way rather than include the security group definitions in the repo because I prefer that all security related functions, including (especially) IAM entities and security groups be under a separate, more stringent security regime, so as to reduce potential "blast radius" in the event a bad actor gets access to the code.

This repo contains the following:

1. The package.json file and ./sre and ./bin directories contain the pre-packaged node.js web application provided by Rearc.
1. Dockerfile is the Dockerfile to package the application into a container.
1. The upload_image.sh file transfers the Docker container image to AWS ECR.  It takes one argument, the container ID of the container image to be transferred.
1. The rearc.tf, variables.tf, and terraform.tfvars files contain the IaC code for Terraform to create the ECS container with Application Load Balancer front end to complete the task.

## Build

1. Run "aws configure" and follow the instructions to enable the AWS CLI to run in your AWS account.
1. Make sure Docker is running.
1. Run "docker build ."
1. Run "docker images" and record the container id of the container
1. Run "upload_images.sh" followed by the container id recorded above.
