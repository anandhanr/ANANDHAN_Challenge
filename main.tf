variable "name" {
  description = "the name of your stack, e.g. \"turnberry\""
  default     = "turnberry"
}

variable "environment" {
  description = "the name of your environment, e.g. \"prod-west\""
  default     = "dev-east"
}

variable "key_name" {
  description = "the name of the ssh key to use, e.g. \"internal-key\""
  default     = "terraform"
}

variable "ami_id" {
  description = "the ami to launch web-server"
  default     = "ami-0c322300a1dd5dc79"
}

variable "region" {
  description = "the AWS region in which resources are created, you must set the availability_zones variable as well if you define this value to something other than the default"
  default     = "us-east-1"
}

variable "cidr" {
  description = "the CIDR block to provision for the VPC, if set to something other than the default, both internal_subnets and external_subnets have to be defined as well"
  default     = "192.168.0.0/16"
}

variable "public_subnet" {
  description = "the CIDR for public subnet in your VPC, must be set if the cidr variable is defined, needs to have as many elements as there are availability zones"
  default     = "192.168.0.0/24"
}

variable "availability_zone" {
  description = "a comma-separated list of availability zones, defaults to all AZ of the region, if set to something other than the defaults, both internal_subnets and external_subnets have to be defined as well"
  default     = "us-east-1a"
}

variable "web_instance_type" {
  description = "Instance type for the bastion"
  default = "t2.micro"
}

provider "aws" {
  version = ">= 1.17.0"
  region  = "${var.region}"
}

module "vpc" {
  source             = "./vpc"
  name               = "${var.name}"
  cidr               = "${var.cidr}"
  public_subnet     = "${var.public_subnet}"
  availability_zone = "${var.availability_zone}"
  environment        = "${var.environment}"
}

// The region in which the infra lives.
output "region" {
  value = "${var.region}"
}

// Comma separated list of public subnet IDs.
output "public_subnet" {
  value = "${module.vpc.public_subnet}"
}

// The environment of the stack, e.g "prod".
output "environment" {
  value = "${var.environment}"
}

// The VPC availability zones.
output "availability_zone" {
  value = "${module.vpc.availability_zone}"
}

// The VPC ID.
output "vpc_id" {
  value = "${module.vpc.id}"
}

// The external route table ID.
output "external_route_tables" {
  value = "${module.vpc.external_rtb_id}"
}
output "web_server_ip_address" {
  value = "${module.vpc.external_ip}"
}