output "vpc_id" {
  value = aws_vpc.mainvpc.id
}
output "public_subnet_ids" {
  value = aws_subnet.public_subnets.*.id
}
