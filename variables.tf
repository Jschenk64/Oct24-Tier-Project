# Contains variable declarations for configuration parameters.
variable "region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "eu-central-1"
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["eu-central-1a", "eu-central-1b"]
}


variable "key_name" {
  description = "Key pair name for EC2 instances"
  type        = string
  default     = "eng-de"
}

variable "ami_id" {
  description = "The AMI ID for the EC2 instances"
  type        = string
  default     = "ami-0084a47cc718c111a"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.49.0.0/16"
}

variable "public_subnet_cidr" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.49.1.0/24", "10.49.2.0/24"] # Example CIDR blocks
}

variable "private_subnet_cidr" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.49.3.0/24", "10.49.4.0/24"] # Example CIDR blocks
}


