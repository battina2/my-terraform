#expense main  network
provider "aws" {
  region = var.region  # Change this to your desired AWS region
}

module "my_vpc" {
  source = "./modules/network-vpc"
  vpc_name             = var.vpc_name
  cidr_block_vpc           = var.cidr_block_vpc
  enable_dns_support   = var.enable_dns_hostnames
  enable_dns_hostnames = var.enable_dns_support
}
# VPC output  vpc ID
output "main_vpc_id" {
  value = module.my_vpc.vpc_id
}

#create Public Subnets
module "public_subnets"{
  source = "./modules/network_subnet"
  env    = var.env
  subnet_configs = var.public_subnet_configs
  vpc_id = module.my_vpc.vpc_id
 }
# Subnet output subnet ID
output "public_subnet_ids" {
  value = module.public_subnets.subnet_ids[*]
}
output "public_subnet_names" {
  value = module.public_subnets.subnet_name[*]
}
#create web Subnets
module "web_subnet"{
  source = "./modules/network_subnet"
  env    = var.env
  subnet_configs = var.web_subnet_configs
  vpc_id = module.my_vpc.vpc_id
  }
# Subnet output subnet ID
output "web_subnet_ids" {
  value = module.web_subnet.subnet_ids[*]
}
output "web_subnet_name" {
  value = module.web_subnet.subnet_ids[*]
}

#create app Subnets
module "app_subnet"{
  source = "./modules/network_subnet"
  env    = var.env
  subnet_configs = var.app_subnet_configs
  vpc_id = module.my_vpc.vpc_id
}
# Subnet output subnet ID
output "app_subnet_ids" {
  value = module.app_subnet.subnet_ids[*]
}
output "app_subnet_name" {
  value = module.app_subnet.subnet_name[*]
}
#create db Subnets
module "db_subnet"{
  source = "./modules/network_subnet"
  env    = var.env
  subnet_configs = var.db_subnet_configs
  vpc_id = module.my_vpc.vpc_id
}
# Subnet output subnet ID
output "db_subnet_ids" {
  value = module.db_subnet.subnet_ids[*]
}
output "db_subnet_name" {
  value = module.db_subnet.subnet_name[*]
}

# create internet gateway
resource "aws_internet_gateway" "igw-dev" {
 vpc_id = module.my_vpc.vpc_id  # Replace with your VPC ID
}
output "internet_gateway_id" {
  value = aws_internet_gateway.igw-dev.id
}

# Create an Elastic IP for the NAT Gateway
resource "aws_eip" "my_eip" {}

# Create a NAT Gateway in the public subnet
resource "aws_nat_gateway" "my_nat_gateway" {
  allocation_id = aws_eip.my_eip.id
  subnet_id     = module.public_subnets.subnet_ids[0]
}

# Output the public IP address of the NAT Gateway
output "nat_gateway_public_ip" {
  value = aws_nat_gateway.my_nat_gateway.public_ip
}
# Create a custom route table for the public subnet
resource "aws_route_table" "public_route_table" {
  vpc_id = module.my_vpc.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-dev.id
  }
  tags = {
    Name = "PublicRouteTable"
  }
}
# Associate the public subnet with the custom route table
# Associate both public subnets with the custom route table
resource "aws_route_table_association" "public_route_association_1" {
  subnet_id      = module.public_subnets.subnet_ids[0]
  route_table_id = aws_route_table.public_route_table.id
}
resource "aws_route_table_association" "public_route_association_2" {
  subnet_id      = module.public_subnets.subnet_ids[1]
  route_table_id = aws_route_table.public_route_table.id
}
# Create a custom route table for the private subnet
resource "aws_route_table" "web_route_table" {
  vpc_id = module.my_vpc.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.my_nat_gateway.id
  }

  tags = {
    Name = "webRouteTable"
  }
}

# Create a custom route table for app private subnet
resource "aws_route_table" "app_route_table" {
  vpc_id = module.my_vpc.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.my_nat_gateway.id
  }

  tags = {
    Name = "appRouteTable"
  }
}

resource "aws_route_table" "db_route_table" {
  vpc_id = module.my_vpc.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.my_nat_gateway.id
  }

  tags = {
    Name = "dbrouteTable"
  }
}
# Associate the private subnet with the custom route table

resource "aws_route_table_association" "web_route_association" {
    for_each = module.web_subnet.subnet_ids
    subnet_id = each.value
    route_table_id = aws_route_table.web_route_table.id
  tags = "web route table association"
}
resource "app_route_table_association" "app_route_association" {
  for_each = module.app_subnet.subnet_ids
  subnet_id = each.value
  route_table_id = aws_route_table.app_route_table.id
  tags = "app route table association"
}

resource "db_route_table_association" "app_route_association" {
  for_each = module.db_subnet.subnet_ids
  subnet_id = each.value
  route_table_id = aws_route_table.db_route_table
  tags = "app route table association"
}
# add routes to web route table
module "web_routes" {
  source                 = "./modules/network_route"
  route_table_id         = aws_route_table.web_route_table.id  # Example: Existing route table ID
  destination_cidr_block = 0.0.0.0/24            # Example: Destination CIDR block
  target_id              = aws_nat_gateway.my_nat_gateway.id  # Example: Internet Gateway ID

    }
output "web_routes_id"{
  value= module.web_routes.route_id
  }

module "app_routes" {
  source                 = "./modules/network_route"
  route_table_id         = aws_route_table.app_route_table.id  # Example: Existing route table ID
  destination_cidr_block = 0.0.0.0/24            # Example: Destination CIDR block
  target_id              = aws_nat_gateway.my_nat_gateway.id  # Example: Internet Gateway ID

}
output "app_routes_id" {
  value= module.app_routes.route_id
}
module "db_routes" {
  source                 = "./modules/network_route"
  route_table_id         = aws_route_table.db_route_table.id  # Example: Existing route table ID
  destination_cidr_block = 0.0.0.0/24            # Example: Destination CIDR block
  target_id              = aws_nat_gateway.my_nat_gateway.id  # Example: Internet Gateway ID

}
output "db_routes_id"{
  value= module.db_routes.route_id
}
# fetch parameter from database
module "db_userid" {
  source          = "./modules/my_parameters"
  parameter_name  = "/expense/database/userid"
}
module "db_password" {
  source          = "./modules/my_parameters"
  parameter_name  = "/expense/database/userid"
}


output "db_user_id" {
  value = module.db_userid.parameter_value
}
output "db_password" {
  value = module.db_password.parameter_value
}

# create database

resource "aws_db_instance" "expence_db" {
  identifier           = "example-sql-db"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "sqlserver-se"
  engine_version       = "14.00.3038.14.v1"
  instance_class       = "db.t2.micro"
  db_name              = "expense-db"
  username             = module.db_userid.parameter_value
  password             = module.db_password.parameter_value
  publicly_accessible  = false
  skip_final_snapshot  = true
}
# create a Auto scale servers

module "web_launch_template" {
  source               = "./module/ec2_autoscale_module"
  instance_type        = var.instance_type
  ami_id               = var.ami_id  # Replace with your AMI ID
  key_name             = var.key_name
  security_group_ids   = module.web_subnet.subnet_ids  # Replace with your security group ID
  max_count_mode_1     = var.max_count_mode_1
  max_count_mode_2     = var.max_count_mode_2
}