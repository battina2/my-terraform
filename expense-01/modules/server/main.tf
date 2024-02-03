resource "aws_instance" "instances" {
    ami             = var.ami
    instance_type   = var.instance_type
    vpc_security_group_ids  = var.sg_id
    tags    = {
         name= "${each.value[name]-${var.env}"
              }
   }
