#!/bin/bash

if [ $# -eq 0 ]; then
  echo "Usage: $0 <container id to be uploaded to ECR>"
  exit 1
fi

docker login -u AWS -p $(aws ecr get-login-password --region <REGION>) <AWS ACCOUNT ID>.dkr.ecr.<REGION>.amazonaws.com

aws ecr get-login-password --region <REGION> | docker login --username AWS --password-stdin <AWS ACCOUNT ID>.dkr.ecr.<REGION>.amazonaws.com

docker tag $1 <AWS ACCOUNT ID>.dkr.ecr.<REGION>.amazonaws.com/<REPO>:<TAG>

docker push <AWS ACCOUNT ID>.dkr.ecr.<REGION>.amazonaws.com/<REPO>:<TAG>
