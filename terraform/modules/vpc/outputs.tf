###### vpc/outputs.tf 
output "aws_public_subnet" {
  value = aws_subnet.public_shah_subnet.*.id
}

output "vpc_id" {
  value = aws_vpc.shah.id
}

output "aws_private_subnet" {
  value = aws_subnet.private_shah_subnet.*.id
}