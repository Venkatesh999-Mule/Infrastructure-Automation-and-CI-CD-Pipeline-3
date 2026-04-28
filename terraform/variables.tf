variable "aws_region" {
  default = "ap-south-1"
}

variable "ami_id" {
  default = "ami-0e12ffc2dd465f6e4"
}

variable "instance_type" {
    default = "t3.small"
  
}

variable "key_name" {
  description = "Devops-project-1"
  type        = string
}