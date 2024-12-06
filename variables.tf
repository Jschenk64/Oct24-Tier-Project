# Contains variable declarations for configuration parameters.
variable "region" {
  description = "The AWS region to deploy resources"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "key_name" {
  description = "Key pair name for EC2 instances"
  type        = string
}

variable "ami_id" {
  description = "The AMI ID for the EC2 instances"
  type        = string
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
  description = "Public subnet CIDR block"
  type        = list(string)
}

variable "private_subnet_cidr" {
  description = "Private subnet CIDR block"
  type        = list(string)
}