variable "vpc_id" {
  type        = string
  description = "The ID of the existing VPC"
}
variable "subnet_configs" {
  type = list(object(
    {
      subnet_name  = string
      subnet_range = string
      az_name      = string
    }))
}
variable env{}
