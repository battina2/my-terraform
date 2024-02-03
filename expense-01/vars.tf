variable "env" {}
variable "cidr_block_vpc" {}
variable "enable_dns_hostnames"{}
variable "enable_dns_support" {}
variable "region"{}
variable "tags" {}
variable "vpc_name"{}
variable "public_subnet_configs" {
  type = list(object(
    {
      subnet_name  = string
      subnet_range = string
      az_name      = string
      subnet_type  = string
    }))
}
variable "web_subnet_configs" {
  type = list(object(
    {
      subnet_name  = string
      subnet_range = string
      az_name      = string
      subnet_type  = string
    }))
}
variable "app_subnet_configs" {
  type = list(object(
    {
      subnet_name  = string
      subnet_range = string
      az_name      = string
      subnet_type  = string
    }))
}
variable "db_subnet_configs" {
  type = list(object(
    {
      subnet_name  = string
      subnet_range = string
      az_name      = string
      subnet_type  = string
    }))
}
variable "subnet_configs" {
  type = list(object(
    {
      subnet_name  = string
      subnet_range = string
      az_name      = string
      subnet_type  = string
    }))
}

variable "db_subnet_ids"  {
  type= list(string)
}
variable "public_subnet_ids"  {
  type= list(string)
}
variable"web_subnet_ids"  {
  type= list(string)
}
variable"app_subnet_ids" {
  type= list(string)
}
variable "instance_type" {
  type        = string
  description = "EC2 instance type"
}

variable "ami_id" {
  type        = string
  description = "AMI ID for the EC2 instances"
}

variable "key_name" {
  type        = string
  description = "Key pair name for EC2 instances"
}

variable "security_group_ids" {
  type        = list(string)
  description = "List of security group IDs for EC2 instances"
}

variable "max_count_mode_1" {
  type        = number
  description = "Max count for the first mode"
}

variable "max_count_mode_2" {
  type        = number
  description = "Max count for the second mode"
}