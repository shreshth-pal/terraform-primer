terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      #  Fix version version of the AWS provider
      version = "= 5.3.0"
    }
  }
}
provider "aws" {
  region                   = var.region
  shared_config_files      = ["/home/shreshth/.aws/config"]
  shared_credentials_files = ["/home/shreshth/.aws/credentials"]
  profile                  = "default"
}

variable "region" {
  description = "The name of the AWS Region"
  type        = string
  default     = "ap-south-1"
}