variable "vpc_name" {
  type        = string
  description = "The name of the VPC"
}

variable "cidr_block_vpc" {
  type        = string
  description = "The CIDR block for the VPC"
}

variable "enable_dns_support" {
  type        = bool
  description = "Enable DNS support in the VPC"
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "Enable DNS hostnames in the VPC"
}


