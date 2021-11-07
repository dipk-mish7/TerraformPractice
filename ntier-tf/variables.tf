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
variable "subnets" {

  type = list(string)
  default = [ "web1","web2","app1","app2","db1","db2"]
  description = "Name of subnets"
  
}

variable "cidrranges" {

  type = list(string)
  default = [ "192.168.0.0/24","192.168.1.0/24","192.168.2.0/24","192.168.3.0/24","192.168.4.0/24","192.168.5.0/24"]
  description = "List of CIDR Ranges"
  
}

variable "subnets-azs" {

  type = list(string)
  default = [ "us-west-2a","us-west-2b","us-west-2a","us-west-2b","us-west-2a","us-west-2b" ]
  
}