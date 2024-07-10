#!/bin/bash

if [ $# -eq 0 ]; then
  echo "Usage: $0 <container id to be uploaded to ECR>"
  exit 1
fi

docker login -u AWS -p $(aws ecr get-login-password --region us-east-1) 508563857051.dkr.ecr.us-east-1.amazonaws.com

aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 508563857051.dkr.ecr.us-east-1.amazonaws.com

docker tag $1 508563857051.dkr.ecr.us-east-1.amazonaws.com/mkw_test:test

docker push 508563857051.dkr.ecr.us-east-1.amazonaws.com/mkw_test:test
