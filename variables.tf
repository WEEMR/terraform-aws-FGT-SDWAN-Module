//Required Variables 
variable access_key {}
variable secret_key {}
// Your first Initial / last name that resources will be tagged with
variable "Resources_Owner" {}
//  Existing SSH Key on the AWS
variable "keyname" {}


// Optional Variables 
variable "region" {
  default = "us-east-1"
}

variable "enviroment" {
  default = "Production"
}

variable "VPC_CIDR_Block" {
  default = "10.150.0.0/16"
}

variable "Public_Subnet_1" {
  description = "FGT WAN 1 Interface Subnet"
  default     = "10.150.1.0/24"
}

variable "Public_Subnet_2" {
  description = "FGT WAN 2 Interface Subnet"
  default     = "10.150.5.0/24"
}

variable "Private_Subnet" {
  description = "FGT LAN Interface Subnet"
  default     = "10.150.2.0/24"
}


// AMIs are for FGTVM-AWS(PAYG) - 7.0
variable "FGT_VM_AMI" {
  type = map
  default = {
    us-east-1 = "ami-01a54d044634cf0f6"
  }
}

variable "FGT_VM_Size" {
  default = "t2.small"
}

variable "adminsport" {
  default = "443"
}

variable "bootstrap-fgtvm" {
  type    = string
  default = "fgtvm.conf"
}