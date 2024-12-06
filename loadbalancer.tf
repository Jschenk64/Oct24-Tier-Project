# Configures the Application Load Balancer with listener and target group.
resource "aws_lb" "win24_alb" {
  name               = "win24-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.win24_alb_sg.id]
  subnets            = aws_subnet.win24_pub_sub[*].id

  enable_deletion_protection = false
}

resource "aws_lb_target_group" "win24_target_group" {
  name     = "win24-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.win24_vpc.id
}

resource "aws_lb_listener" "win24_listener" {
  load_balancer_arn = aws_lb.win24_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.win24_target_group.arn
  }
}