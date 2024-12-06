# Outputs useful information like instance IPs, subnet IDs, and more.
output "availability_zones" {
  description = "Availability Zones"
  value       = var.availability_zones
}

output "subnet_ids" {
  description = "Subnet IDs"
  value       = concat(aws_subnet.win24_pub_sub[*].id, aws_subnet.win24_priv_sub[*].id)
}

output "load_balancer_id" {
  description = "Load Balancer ID"
  value       = aws_lb.win24_alb.id
}

output "database_id" {
  description = "Database ID"
  value       = aws_db_instance.win24_db.id
}

output "provider" {
  description = "Provider"
  value       = "AWS"
}

output "alb_dns_name" {
  description = "DNS name of the load balancer"
  value       = aws_lb.win24_alb.dns_name
}