variable "region" {
    description = "The region where the demo should be deployed"
    type = string
  
}
variable "availability_zone" {
    description = "The availabillity zone to deploy demo systems"
    type = string
  
}

variable "vpc_cidr" {
    description = "the IP CIDR for the demo VPC"
    type = string
}

variable "subnet_cidr" {
    description = "The demo subnet CIDR"
  
}

variable "keypair" {
    description = "The name of the key-pair to use for the instances"
    type = string
  
}

variable "sles" {
    description = "Settings for SLES instances"
    type = map
}

variable "ubuntu" {
    description = "Settings for ubuntu instances"
    type = map
}