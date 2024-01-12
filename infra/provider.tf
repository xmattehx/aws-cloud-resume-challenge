terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}
provider "aws" {
  #profile ="default"
  region = "ca-central-1"
  access_key = var.access_key
  secret_key = var.secret_key
}