variable "state_bucket" {
  default     = "tf-state-cluster"
  type        = string
  description = "Flag to set for terraform s3 bucket"
}

variable "destroy" {
  default     = false
  type        = bool
  description = "Flag to set for terraform s3 bucket"
}

variable "dynamo_table_name" {
  default     = "terraform-up-and-running-locks"
  type        = string
  description = "Flag to set for terraform s3 bucket"
}

variable "aws-region" {
  default     = "eu-west-1"
  type        = string
  description = "The AWS Region to deploy EKS"
}