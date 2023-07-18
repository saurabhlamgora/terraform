# Set variables
variable "aws_region" {
  description = "The AWS region to create a VPC in"
  default = "ap-south-1"

}

variable "environment_name" {
  type        = string
  description = "Set environment name"
  default     = ""
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR"
  //default     = []
}

variable "availability_zone" {
  description = "Availability Zone"
  default     = []
}

variable "private_subnet_cidr" {
  description = "Private subnets for VPC"
  type        = list(string)
  default     = []
}

variable "public_subnet_cidr" {
  description = "Private subnets for VPC"
  type        = list(string)
  default     =  []
}



