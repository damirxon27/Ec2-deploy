terraform {
  cloud {

    organization = "DAMIRXON"

    workspaces {
      name = "my_first_workspace"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
provider "aws" {
  region = "us-east-1"
}
 