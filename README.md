### Repo for Rearc "Quest in the Clouds"

## Introduction
This repo contains Matthew White's solution to the Rearc "Quest in the Clouds" challenge.  It consists of Terraform and bash shell code and the code needed to containerize a node.js web application provided by Rearc.

## Getting Started

Prerequisites:
1. That you have the AWS CLI, Terraform and Docker already installed on the computer you are using to install this repo.
1. That you have access to an AWS account with a login with administrative access and an access key/secret key pair, and with that the AWS CLI working in that account.W
1. That the AWS account has a pre-existing VPC with at least two publicly accessible subnets.

This repo contains the following:

1. The package.json file and ./sre and ./bin directories contain the pre-packaged node.js web application provided by Rearc.
1. Dockerfile is the Dockerfile to package the application into a container.
1. 
