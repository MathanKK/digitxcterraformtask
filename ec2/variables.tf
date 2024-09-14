variable "aws_region" {
  description = "The AWS region to deploy the resources in"
  default     = "us-east-1"
}

variable "ami_id" {
  description = "AMI ID for Ubuntu 22.04 LTS"
  default     = "ami-0a0e5d9c7acc336f1" # Change based on region if needed
}

variable "instance_type" {
  description = "The type of instance to deploy"
  default     = "t2.micro"
}
