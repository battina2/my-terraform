variable "parameter_name" {
  type        = string
  description = "Name of the parameter in SSM Parameter Store"
}

data "aws_ssm_parameter" "fetched_parameter" {
  name = var.parameter_name
}