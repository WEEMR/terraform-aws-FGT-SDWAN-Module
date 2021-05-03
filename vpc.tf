// AWS VPC
resource "aws_vpc" "SDWAN_VPC" {
  cidr_block           = var.VPC_CIDR_Block
  enable_dns_support   = true
  enable_dns_hostnames = true
  enable_classiclink   = false
  instance_tenancy     = "default"



  tags = {
    Name       = "${var.Resources_Owner}_VPC"
    Owner      = var.Resources_Owner
    Enviroment = var.enviroment
    Creator    = "${var.Resources_Owner} via Terraform"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "SDWAN_Public_Subnet_1" {
  vpc_id            = aws_vpc.SDWAN_VPC.id
  cidr_block        = var.Public_Subnet_1
  availability_zone = data.aws_availability_zones.available.names[0]



  tags = {
    Name       = "${var.Resources_Owner}_SDAWN_Public_Subnet_1"
    Owner      = var.Resources_Owner
    Enviroment = var.enviroment
    Creator    = "${var.Resources_Owner} via Terraform"
  }
}

resource "aws_subnet" "SDWAN_Public_Subnet_2" {
  vpc_id            = aws_vpc.SDWAN_VPC.id
  cidr_block        = var.Public_Subnet_2
  availability_zone = data.aws_availability_zones.available.names[0]


  tags = {
    Name       = "${var.Resources_Owner}_SDAWN_Public_Subnet_2"
    Owner      = var.Resources_Owner
    Enviroment = var.enviroment
    Creator    = "${var.Resources_Owner} via Terraform"

  }
}

resource "aws_subnet" "SDWAN_Private_Subnet_1" {
  vpc_id            = aws_vpc.SDWAN_VPC.id
  cidr_block        = var.Private_Subnet
  availability_zone = data.aws_availability_zones.available.names[0]


  tags = {
    Name       = "${var.Resources_Owner}_SDAWN_Private_Subnet_1"
    Owner      = var.Resources_Owner
    Enviroment = var.enviroment
    Creator    = "${var.Resources_Owner} via Terraform"

  }
}

