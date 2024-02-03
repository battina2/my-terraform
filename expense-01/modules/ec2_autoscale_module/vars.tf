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
