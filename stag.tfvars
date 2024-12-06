# Contains variable values specific to the staging environment.
region              = "eu-west-1"
availability_zones  = ["eu-west-1a", "eu-west-1b"]
key_name            = "win24"
ami_id              = "ami-0e9085e60087ce171"
vpc_cidr            = "10.49.0.0/16"
public_subnet_cidr  = ["10.49.105.0/24", "10.49.106.0/24"]
private_subnet_cidr = ["10.49.107.0/24", "10.49.108.0/24"]