#!/usr/bin/env bash

cd infra

terraform init
terraform validate
terraform plan -out plan
terraform apply -auto-approve plan

aws eks --region eu-west-1 update-kubeconfig --name "eks-sample-app"

TRUST="{ \"Version\": \"2012-10-17\", \"Statement\": [ { \"Effect\": \"Allow\", \"Principal\": { \"AWS\": \"arn:aws:iam::${ACCOUNT_ID}:root\" }, \"Action\": \"sts:AssumeRole\" } ] }"
echo '{ "Version": "2012-10-17", "Statement": [ { "Effect": "Allow", "Action": "eks:Describe*", "Resource": "*" } ] }' > /tmp/iam-role-policy

aws iam create-role --role-name CodePipelineKubectlRole --assume-role-policy-document "$TRUST" --output text --query 'Role.Arn'
aws iam put-role-policy --role-name CodePipelineKubectlRole --policy-name eks-describe --policy-document file:///tmp/iam-role-policy


ROLE="    - rolearn: arn:aws:iam::${ACCOUNT_ID}:role/CodePipelineKubectlRole\n      username: build\n      groups:\n        - system:masters"
kubectl get -n kube-system configmap/aws-auth -o yaml | awk "/mapRoles: \|/{print;print \"$ROLE\";next}1" > /tmp/aws-auth-patch.yml
kubectl patch configmap/aws-auth -n kube-system --patch "$(cat /tmp/aws-auth-patch.yml)"

aws cloudformation deploy --template-file ./cicd-cloudformation/cicd-codepipeline.yaml --stack-name eks-codepipeline --parameter-overrides GitHubUser=azarudeena --parameter-overrides GitHubToken=$GITHUB_TOKEN
