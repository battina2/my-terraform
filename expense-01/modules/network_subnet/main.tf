# expense01/modules/network_subnets
resource "aws_subnet" "my_subnet" {
  count = length(var.subnet_configs)
  vpc_id                  = var.vpc_id  # Replace with your VPC ID
  cidr_block              = var.subnet_configs[count.index].subnet_range
  availability_zone       = var.subnet_configs[count.index].az_name
  map_public_ip_on_launch = true

  tags = {
    Name = var.subnet_configs[count.index].subnet_name
  }
 }
