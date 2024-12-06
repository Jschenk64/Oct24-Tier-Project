# Configures the RDS instance and its subnet group.
resource "aws_db_instance" "win24_db" {
  identifier         = "win24-db-instance"
  engine             = "mysql"
  instance_class     = "db.t2.micro"
  allocated_storage  = 20
  name               = "webappdb"
  username           = "admin"
  password           = "password"
  skip_final_snapshot = true
  publicly_accessible = false
  vpc_security_group_ids = [aws_security_group.win24_db_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.win24_db_subnet_group.name
}

resource "aws_db_subnet_group" "win24_db_subnet_group" {
  name       = "win24-db-subnet-group"
  subnet_ids = aws_subnet.win24_priv_sub[*].id

  tags = {
    Name = "win24-db-subnet-group"
  }
}

