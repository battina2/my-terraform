output "subnet_ids" {
  value = aws_subnet.my_subnet[count.index].id
}
output "subnet_name" {
  value = aws_subnet.my_subnet.tags[count.index].Name
}