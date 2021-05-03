
output "FGT_WAN1_IP" {
  value = aws_eip.FGT_WAN1_IP.public_ip
}

output "FGT_WAN2_IP" {
  value = aws_eip.FGT_WAN2_IP.public_ip
}

output "Username" {
  value = "admin"
}

output "FGT_Password" {
  value = aws_instance.FGT.id
}