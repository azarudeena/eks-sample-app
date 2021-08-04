#!/bin/bash

aws cloudformation delete-stack --stack-name eks-codepipeline

cd ../infra/

terraform init
terraform plan -destroy
terraform destroy