output "vpc_id" {
  description = "The ID of VPC"
  value = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "CIDR of the VPC"
  value = aws_vpc.main.cidr_block
}



