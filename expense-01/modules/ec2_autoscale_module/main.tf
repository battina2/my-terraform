resource "aws_launch_template" "my_autoscale_servers" {
  name          = "myserver-launch-template"
  version       = "$Latest"

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 20
      volume_type = "gp3"
    }
  }

  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }

  instance_market_options {
    market_type = "spot"
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "example-instance"
    }
  }

  metadata_options {
    http_tokens = "optional"
  }

  monitoring {
    enabled = false
  }

  credit_specification {
    cpu_credits = "standard"
  }

  network_interfaces {
    associate_public_ip_address = true
  }

  instance_type = var.instance_type
  key_name      = var.key_name
  image_id      = var.ami_id

  security_group_names = var.security_group_ids
}

resource "aws_autoscaling_group" "my_autoscale_ec2" {
  desired_capacity     = var.max_count_mode_1
  max_size             = var.max_count_mode_1
  min_size             = 0
  vpc_zone_identifier  = ["subnet-xxxxxxxxxxxxxxxxx"]  # Replace with your subnet ID
  launch_template {
    id      = aws_launch_template.my_autoscale_servers.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_policy" "mode_switch_policy" {
  name                   = "mode-switch-policy"
  scaling_adjustment    = var.max_count_mode_2 - var.max_count_mode_1
  adjustment_type       = "ChangeInCapacity"
  cooldown              = 300
  scaling_adjustment_type = "ExactCapacity"
  cooldown_action        = "Default"
  autoscaling_group_name = aws_autoscaling_group.my_autoscale_ec2
}