# Defines EC2 instances, security groups, and autoscaling configurations.
resource "aws_security_group" "win24_web_sg" {
  vpc_id = aws_vpc.win24_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "win24_web_sg"
  }
}

resource "aws_security_group" "win24_app_sg" {
  vpc_id = aws_vpc.win24_vpc.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.win24_web_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "win24_app_sg"
  }
}

resource "aws_launch_template" "win24_web_launch_template" {
  name_prefix   = "win24-web-lt"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name   # Ensure this line uses the correct key name

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.win24_web_sg.id]
  }

  user_data = base64encode(<<-EOF
                #!/bin/bash
                sudo apt-get update
                sudo apt-get install -y nginx
                sudo systemctl start nginx
                sudo systemctl enable nginx
              EOF
  )
}

resource "aws_autoscaling_group" "win24_web_asg" {
  launch_template {
    id      = aws_launch_template.win24_web_launch_template.id
    version = "$Latest"
  }
  min_size           = 2
  max_size           = 4
  desired_capacity   = 2
  vpc_zone_identifier = aws_subnet.win24_pub_sub[*].id

  target_group_arns = [aws_lb_target_group.win24_target_group.arn]

  tag {
    key                 = "Name"
    value               = "BIE-SVWEB56"
    propagate_at_launch = true
  }
}

resource "aws_launch_template" "win24_app_launch_template" {
  name_prefix   = "win24-app-lt"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  network_interfaces {
    security_groups = [aws_security_group.win24_app_sg.id]
  }

  user_data = base64encode(<<-EOF
                #!/bin/bash
                sudo apt-get update
                # Your application server setup script
              EOF
  )
}

resource "aws_autoscaling_group" "win24_app_asg" {
  launch_template {
    id      = aws_launch_template.win24_app_launch_template.id
    version = "$Latest"
  }
  min_size           = 2
  max_size           = 4
  desired_capacity   = 2
  vpc_zone_identifier = aws_subnet.win24_priv_sub[*].id

  tag {
    key                 = "Name"
    value               = "BIE-SVAPP57"
    propagate_at_launch = true
  }
}

resource "aws_security_group" "win24_db_sg" {
  vpc_id = aws_vpc.win24_vpc.id

  // Allow inbound traffic from the application servers
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.win24_app_sg.id]
  }

  // Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "win24_db_sg"
  }
}

resource "aws_security_group" "win24_alb_sg" {
  vpc_id = aws_vpc.win24_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "win24_alb_sg"
  }
}