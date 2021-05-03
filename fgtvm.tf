// FGTVM instance

resource "aws_network_interface" "eth0" {
  description = "FGT-port1"
  subnet_id   = aws_subnet.SDWAN_Public_Subnet_1.id
}

resource "aws_network_interface" "eth1" {
  description = "FGT-port2"
  subnet_id   = aws_subnet.SDWAN_Public_Subnet_2.id
}

resource "aws_network_interface" "eth2" {
  description       = "FGT-port3"
  subnet_id         = aws_subnet.SDWAN_Private_Subnet_1.id
  source_dest_check = false
}


resource "aws_network_interface_sg_attachment" "attach_eth0_with_sg" {
  depends_on           = [aws_network_interface.eth0]
  security_group_id    = aws_security_group.public_allow.id
  network_interface_id = aws_network_interface.eth0.id
}

resource "aws_network_interface_sg_attachment" "attach_eth1_with_sg" {
  depends_on           = [aws_network_interface.eth1]
  security_group_id    = aws_security_group.public_allow.id
  network_interface_id = aws_network_interface.eth1.id
}

resource "aws_network_interface_sg_attachment" "attach_eth2_with_sg" {
  depends_on           = [aws_network_interface.eth2]
  security_group_id    = aws_security_group.allow_all.id
  network_interface_id = aws_network_interface.eth2.id
}


resource "aws_instance" "FGT" {
  ami               = lookup(var.FGT_VM_AMI, var.region)
  instance_type     = var.FGT_VM_Size
  availability_zone = data.aws_availability_zones.available.names[0]
  key_name          = var.keyname
  user_data         = data.template_file.FortiGate.rendered

  root_block_device {
    volume_type = "standard"
    volume_size = "2"
  }

  ebs_block_device {
    device_name = "/dev/sdb"
    volume_size = "30"
    volume_type = "standard"
  }

  network_interface {
    network_interface_id = aws_network_interface.eth0.id
    device_index         = 0
  }

  network_interface {
    network_interface_id = aws_network_interface.eth1.id
    device_index         = 1
  }

  network_interface {
    network_interface_id = aws_network_interface.eth2.id
    device_index         = 2
  }

  tags = {
    Name       = "${var.Resources_Owner}_FGT_SDWAN"
    Owner      = var.Resources_Owner
    Enviroment = var.enviroment
    Creator    = "${var.Resources_Owner} via Terraform"
  }
}


data "template_file" "FortiGate" {
  template = "${file("${var.bootstrap-fgtvm}")}"
  vars = {
    adminsport = "${var.adminsport}"
  }
}

