# Contains variable values specific to the staging environment.
region              = "eu-west-1"
availability_zones  = ["eu-west-1a", "eu-west-1b"]
key_name            = "Ansi"
ami_id              = "ami-0e9085e60087ce171"
vpc_cidr            = "10.49.0.0/16"
public_subnet_cidr  = ["10.49.15.0/24", "10.49.16.0/24"]
private_subnet_cidr = ["10.49.17.0/24", "10.49.18.0/24"]