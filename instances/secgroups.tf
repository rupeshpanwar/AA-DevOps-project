resource "aws_security_group" "elb_security_group" {
  name = "ELB-SG"
  description = "ELB Security Group"
  vpc_id = data.terraform_remote_state.network-configuration.outputs.vpc_id

  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow web traffic to load balancer"
  }

  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name ="elb_security_group"
  }
}

resource "aws_security_group" "ec2_public_security_group" {
  name        = "EC2-public-scg"
  description = "Internet reaching access for public EC2 instance"
  vpc_id      = data.terraform_remote_state.network-configuration.outputs.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.elb_security_group.id]
  }

  ingress  {
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "sshing..."
    from_port = 22
    protocol = "tcp"
    to_port = 22
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2_public_security_group"
  }

  depends_on = ["aws_security_group.elb_security_group"]
}

