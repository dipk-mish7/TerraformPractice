variable "region" {
  type = string
  default = "us-west-2"
  description = "It is used to create Ntier Vpc"
  
}

variable "vpccidr" {

  type = string
  default = "192.168.0.0/16"
  description = "This is to define VPC CIDR"
  
}