data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical

}




module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"

  # Autoscaling group
  name = "example-asg"

  min_size                  = 0
  max_size                  = 1
  desired_capacity          = 1
  wait_for_capacity_timeout = 0
  health_check_type         = "EC2"
  security_groups =  [aws_security_group.class2-ec2.id]
  availability_zones       = [
  "us-east-1a", 
  "us-east-1b",
  "us-east-1c",
  ]


  # Launch template
  launch_template_name        = "example-asg"
  launch_template_description = "Launch template example"
  update_default_version      = true

  image_id          = data.aws_ami.ubuntu.id
  instance_type     = "t3.micro"
  ebs_optimized     = true
  enable_monitoring = true

}

# Create sec group
resource "aws_security_group" "class2-ec2" {
  name        = "class2-ec2"
  description = "Allow TLS inbound traffic and all outbound traffic"
}

# Add ingress rule to sec group
resource "aws_vpc_security_group_ingress_rule" "allow_tls_22" {
  security_group_id = aws_security_group.class2-ec2.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

# Add ingress rule to sec group
resource "aws_vpc_security_group_ingress_rule" "allow_tls_80" {
  security_group_id = aws_security_group.class2-ec2.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

# Add egress rule to sec group
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.class2-ec2.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# Creates LB
resource "aws_elb" "bar" {
  name = "foobar-terraform-elbs"
  availability_zones = [
    "us-east-1a",
    "us-east-1b",
    "us-east-1c",
  ]
  security_groups = [aws_security_group.class2-ec2.id]
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:80"
    interval            = 30
  }
  cross_zone_load_balancing   = true
  idle_timeout                = 300
  connection_draining         = true
  connection_draining_timeout = 300
}

# Attachs ASG to LB
resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = module.asg.autoscaling_group_id
  elb                    = aws_elb.bar.id
}