### VPC

# use terraform cloud remote backend OR you can use your prefered remote backend
terraform {

  required_version = "~> 1.0.0"

  backend "s3" {
    bucket         = "tf-state-cluster"
    key            = "terraform/terrform_cluster.tfstate"
    dynamodb_table = "terraform-up-and-running-locks"
    region         = "eu-west-1"
    encrypt        = "true"
  }
}


module "eks" {
  source = "./eks"

  aws-region          = var.aws-region
  availability-zones  = var.availability-zones
  cluster-name        = var.cluster-name
  k8s-version         = var.k8s-version
  node-instance-type  = var.node-instance-type
  desired-capacity    = var.desired-capacity
  max-size            = var.max-size
  min-size            = var.min-size
  vpc-subnet-cidr     = var.vpc-subnet-cidr
  private-subnet-cidr = var.private-subnet-cidr
  public-subnet-cidr  = var.public-subnet-cidr
  db-subnet-cidr      = var.db-subnet-cidr
  eks-cw-logging      = var.eks-cw-logging
}

output "kubeconfig" {
  value = module.eks.kubeconfig
}
