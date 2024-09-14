# digitxcterraformtask
digitxcterraformtask

# AWS CLI Configuration

Before proceeding, create an IAM user and configure your AWS CLI with the required permissions.

### Steps:

1. **Create IAM User:**
   - Go to **IAM** in the AWS Console.
   - Create a user with **Programmatic access**.
   - Attach required policy (e.g., `AmazonS3FullAccess` or custom).
   - Download the **Access Key** and **Secret Key**.

2. **Configure AWS CLI:**
   - Run `aws configure` in your terminal.
   - Enter the Access Key, Secret Key, default region (e.g., `us-east-1`), and output format (e.g., `json`).

3. **Verify Configuration:**
   Run `aws sts get-caller-identity` to confirm the setup.

You're now ready to proceed!


1.An AWS EC2 instance running a basic web server.
Write Terraform configuration files to provision this infrastructure.
Requirements:
Create an EC2 instance with the following specifications:
Instance Type: t2.micro
AMI: Ubuntu Server 20.04 LTS
Security Group: Allow incoming HTTP (port 80) and SSH (port 22) traffic.
Instructions:
Create a directory named terraform_challenge.
Inside the directory, create the following Terraform files:
main.tf: Define your resources here.
variables.tf: Define variables for customization.
outputs.tf: Define outputs for displaying useful information.

Ans :

To accomplish the task of creating an EC2 instance using Terraform, you need to create a directory terraform_challenge and inside it, write the Terraform configuration files (main.tf, variables.tf, and outputs.tf). Below is a step-by-step guide, including the Terraform code needed for each file.
1. Create the directory and files:
mkdir terraform_challenge
cd terraform_challenge
touch main.tf variables.tf outputs.tf
2. main.tf - Define resources (EC2, Security Group, etc.)
This file contains the resource definition for the EC2 instance, VPC, security group, and other necessary configurations.

provider "aws" {
  region = var.aws_region
}

# Security group allowing HTTP (port 80) and SSH (port 22) traffic
resource "aws_security_group" "allow_http_ssh" {
  name        = "allow_http_ssh"
  description = "Allow HTTP and SSH traffic"

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_http_ssh_sg"
  }
}

# EC2 instance with Apache web server installed
resource "aws_instance" "ec2_instance" {
  ami             = var.ami_id
  instance_type   = var.instance_type
  security_groups = [aws_security_group.allow_http_ssh.name]

  # User data script to install Apache web server
  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install apache2 -y
              sudo systemctl start apache2
              sudo systemctl enable apache2
              echo "<html><body><h1>Hello from Terraform EC2!</h1></body></html>" | sudo tee /var/www/html/index.html
              EOF

  tags = {
    Name = "terraform_challenge_instance"
  }
}

3. variables.tf - Define variables for customization
This file contains variable definitions that allow you to customize the configuration without hardcoding values.
variable "aws_region" {
  description = "The AWS region to deploy the resources in"
  default     = "us-east-1"
}

variable "ami_id" {
  description = "AMI ID for Ubuntu 22.04 LTS"
  default     = "ami-0a0e5d9c7acc336f1" # Change based on region if needed
}

variable "instance_type" {
  description = "The type of instance to deploy"
  default     = "t2.micro"
}


4. outputs.tf - Define outputs for displaying useful information
This file defines what information should be displayed after running the Terraform commands.
output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.ec2_instance.id
}

output "public_ip" {
  description = "The public IP of the EC2 instance"
  value       = aws_instance.ec2_instance.public_ip
}

output "instance_public_dns" {
  description = "The public DNS of the EC2 instance"
  value       = aws_instance.ec2_instance.public_dns
}

5. Initialize and Apply Terraform
   
terraform init
terraform plan
terraform apply


2.An AWS RDS MySQL database for storing application data.
Write Terraform configuration files to provision this infrastructure.
Requirements:

Create an RDS MySQL instance with the following specifications:
Instance Class: db.t2.micro
Engine: MySQL
Allow incoming traffic on port 3306 from the EC2 instance's security group.

Instructions:
Create a directory named terraform_challenge.
Inside the directory, create the following Terraform files:
main.tf: Define your resources here.
variables.tf: Define variables for customization.
outputs.tf: Define outputs for displaying useful information.

Ans:

To accomplish the task of creating an Amazon RDS MySQL instance with Terraform, you will need to set up a project with the files main.tf, variables.tf, and outputs.tf. Below is the detailed code to guide you through this:
Step 1: Create Directory
mkdir terraform_challenge
cd terraform_challenge
Step 2: Terraform Files
1. main.tf (Resource Definition)
This file will define the RDS instance and its dependencies (e.g., VPC, security group).
provider "aws" {
  region = var.aws_region
}

# Create a Security Group for the RDS instance
resource "aws_security_group" "rds_sg" {
  name        = "rds_security_group"
  description = "Allow MySQL traffic from EC2 instance"

  # Allow inbound MySQL traffic (port 3306)
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Or restrict to specific CIDR range
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "RDS Security Group"
  }
}

# RDS instance
resource "aws_db_instance" "mysql" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = var.instance_class
  db_name              = var.db_name
  username             = var.db_username
  password             = var.db_password
  parameter_group_name = "default.mysql8.0"
  publicly_accessible  = true
  skip_final_snapshot  = true
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  tags = {
    Name = "MySQL RDS"
  }
}


2. variables.tf (Customizable Variables)
This file defines variables that can be customized without editing the main file.
variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "instance_class" {
  description = "RDS instance class"
  default     = "db.t3.micro"
}

variable "db_name" {
  description = "The name of the database"
  type    = string
  default     = "mydb"
}

variable "db_username" {
  description = "The master username for the database"
  default     = "admin"
}

variable "db_password" {
  description = "The master password for the database"
  default     = "password123"
  sensitive   = true
}


3. outputs.tf (Outputs)
This file will output useful information such as the endpoint of the RDS instance.
output "rds_endpoint" {
  description = "The endpoint of the MySQL RDS instance"
  value       = aws_db_instance.mysql.endpoint
}

output "rds_instance_id" {
  description = "The ID of the RDS instance"
  value       = aws_db_instance.mysql.id
}


5. Initialize and Apply Terraform
   
terraform init
terraform plan
terraform apply
