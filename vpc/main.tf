variable "cidr" {
  description = "The CIDR block for the VPC."
}

variable "public_subnet" {
  description = "The CIDR blocks for the public subnet"
}

variable "environment" {
  description = "Environment tag, e.g prod"
}

variable "availability_zone" {
  description = "The target availability zone"
}

variable "name" {
  description = "Name tag, e.g stack"
  default     = "stack"
}

variable "ami_id" {
  description = "the ami to launch web-server"
  default     = "ami-0c322300a1dd5dc79"
}

/**
 * VPC
 */

resource "aws_vpc" "main" {
  cidr_block           = "${var.cidr}"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.name}"
    Environment = "${var.environment}"
  }
}

/**
 * Internet Gateway
 */

resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name        = "${var.name}"
    Environment = "${var.environment}"
  }
}

/**
 * Public Subnet
 */
resource "aws_subnet" "public" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${var.public_subnet}"
  availability_zone       = "${var.availability_zone}"
  //count                   = "${length(var.public_subnet)}"
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.name}-public-subnet"
    Environment = "${var.environment}"
  }
}

/**
 * Route tables
 */

resource "aws_route_table" "external" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name        = "${var.name}-external-001"
    Environment = "${var.environment}"
  }
}

resource "aws_route" "external" {
  route_table_id         = "${aws_route_table.external.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.main.id}"
}

/**
 * Route associations
 */
 resource "aws_route_table_association" "external" {
  //count          = "${length(var.public_subnets)}"
  subnet_id      = "${aws_subnet.public.id}"
  route_table_id = "${aws_route_table.external.id}"
}

resource "aws_security_group" "web" {
  name        = "web_server"
  description = "Allow inbound from Any machine for demo-purpose"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  ami           = "${var.ami_id}"
  instance_type = "t2.micro"
  key_name = "turnberry"
  vpc_security_group_ids = ["${aws_security_group.web.id}"]
  subnet_id = "${aws_subnet.public.id}"
  
  tags = {
    Name = "HelloWorld"
  }
}

/**
 * Outputs
 */

// The VPC ID
output "id" {
  value = "${aws_vpc.main.id}"
}

// The VPC CIDR
output "cidr_block" {
  value = "${aws_vpc.main.cidr_block}"
}

// A comma-separated list of subnet IDs.
output "public_subnet" {
  value = ["${aws_subnet.public.id}"]
}

// The list of availability zones of the VPC.
output "availability_zone" {
  value = "${aws_subnet.public.availability_zone}"
}

// The external route table ID.
output "external_rtb_id" {
  value = "${aws_route_table.external.id}"
}

// Web-server external IP address.
output "external_ip" {
  value = "${aws_instance.web.public_ip}"
}