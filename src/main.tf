###############################################################################
# Setup
###############################################################################
provider "aws" {
  version = "~> 2.23"
  region  = "us-east-1"
}

provider "null" {
  version = "~> 2.1"
}

terraform {
  backend "s3" {
    bucket         = "com.iac-example"
    key            = "network-infrastructure"
    region         = "us-east-1"
    dynamodb_table = "terraform-statelock"
  }
}

###############################################################################
# Local Variables
###############################################################################
locals {
  app_domains               = [
    "swarm-apps.com"
  ]
  availability_zones        = [
    "us-east-1a",
    "us-east-1b"
  ]
  description_tag           = "Managed By Terraform"
  group_tag                 = "Network Infrastructure"
  primary_domain            = "iac-example.com"
  vpc_cidr_block            = "172.32.0.0/16"
}

###############################################################################
# Network Infrastructure
###############################################################################
module "network" {
  source = "./modules/network"

  availability_zones = "${local.availability_zones}"
  description_tag    = "${local.description_tag}"
  group_tag          = "${local.group_tag}"
  vpc_cidr_block     = "${local.vpc_cidr_block}"
}

###############################################################################
# DNS
###############################################################################
module "dns" {
  source = "./modules/dns"

  description_tag = "${local.description_tag}"
  domains         = "${concat([local.primary_domain], local.app_domains)}"
  group_tag       = "${local.group_tag}"
}
