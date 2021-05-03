// Creating Internet Gateway
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.SDWAN_VPC.id


  tags = {
    Name       = "${var.Resources_Owner}_Terraform_IGW"
    Owner      = var.Resources_Owner
    Enviroment = var.enviroment
    Creator    = "${var.Resources_Owner} via Terraform"
  }
}

// Route Table

// Virgina Public Route Table  (Main / Default Route Table)

resource "aws_default_route_table" "Public_Subnet_RT" {
  default_route_table_id = aws_vpc.SDWAN_VPC.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }

  tags = {
    Name       = "${var.Resources_Owner}_FGT_SDWAN_Public_RT"
    Owner      = var.Resources_Owner
    Enviroment = var.enviroment
    Creator    = "${var.Resources_Owner} via Terraform"
  }
}

// Virgina Private Subnet Route Table

resource "aws_route_table" "Private_Subnet_RT" {
  vpc_id = aws_vpc.SDWAN_VPC.id

  tags = {
    Name       = "${var.Resources_Owner}_FGT_SDWAN_Private_RT"
    Owner      = var.Resources_Owner
    Enviroment = var.enviroment
    Creator    = "${var.Resources_Owner} via Terraform"

  }
}


resource "aws_route_table_association" "public_subnet_1_association_with_public_rt" {
  subnet_id      = aws_subnet.SDWAN_Public_Subnet_1.id
  route_table_id = aws_default_route_table.Public_Subnet_RT.id
}

resource "aws_route_table_association" "public_subnet_2_association_with_public_rt" {
  subnet_id      = aws_subnet.SDWAN_Public_Subnet_2.id
  route_table_id = aws_default_route_table.Public_Subnet_RT.id
}


resource "aws_route_table_association" "private_subnet_association_with_private_rt" {
  subnet_id      = aws_subnet.SDWAN_Private_Subnet_1.id
  route_table_id = aws_route_table.Private_Subnet_RT.id
}

resource "aws_eip" "FGT_WAN1_IP" {
  depends_on        = [aws_instance.FGT]
  vpc               = true
  network_interface = aws_network_interface.eth0.id

  tags = {
    Name       = "${var.Resources_Owner}_FGT_WAN1"
    Owner      = var.Resources_Owner
    Enviroment = var.enviroment
    Creator    = "${var.Resources_Owner} via Terraform"
  }
}

resource "aws_eip" "FGT_WAN2_IP" {
  depends_on        = [aws_instance.FGT]
  vpc               = true
  network_interface = aws_network_interface.eth1.id

  tags = {
    Name       = "${var.Resources_Owner}_FGT_WAN2"
    Owner      = var.Resources_Owner
    Enviroment = var.enviroment
    Creator    = "${var.Resources_Owner} via Terraform"
  }
}


// Security Group

resource "aws_security_group" "public_allow" {
  name        = "${var.Resources_Owner}_SDWAN_Public_Allow_SG"
  description = "Public Allow traffic"
  vpc_id      = aws_vpc.SDWAN_VPC.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "6"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "6"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8443
    to_port     = 8443
    protocol    = "6"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name       = "${var.Resources_Owner}_SDWAN_Public_Allow_SG"
    Owner      = var.Resources_Owner
    Enviroment = "Terraform Testing"
    Creator    = "${var.Resources_Owner} via Terraform"
  }
}

resource "aws_security_group" "allow_all" {
  name        = "${var.Resources_Owner}_SDWAN_allow_all_SG"
  description = "Allow all traffic"
  vpc_id      = aws_vpc.SDWAN_VPC.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name       = "${var.Resources_Owner}_SDWAN_allow_all_SG"
    Owner      = var.Resources_Owner
    Enviroment = var.enviroment
    Creator    = "${var.Resources_Owner} via Terraform"
  }
}
