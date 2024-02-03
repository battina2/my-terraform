#module/network-vpc/main

resource "aws_vpc" "srini-vpc"
{
  cidr_block       = var.cidr_block_vpc
  enable_dns_support = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = {
    Name = var.env
  }
}

