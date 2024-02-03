#module to add route
#/modules/network_route
resource "aws_route" "custom_route" {
  route_table_id            = var.route_table_id
  destination_cidr_block    = var.destination_cidr_block
  gateway_id                = var.target_id
}
output "route_id"{
value=aws_route.custom_route.id
}